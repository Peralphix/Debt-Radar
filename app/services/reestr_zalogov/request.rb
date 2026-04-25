# frozen_string_literal: true

class ReestrZalogov::Request
  REESTR_URL = "https://www.reestr-zalogov.ru/search/index".freeze

  def initialize(vin:, headless: true, timeout: 10)
    @vin = vin.to_s.strip
    @timeout = timeout
    @driver = build_driver(headless: headless)
    @wait = Selenium::WebDriver::Wait.new(timeout: @timeout)
  end

  def call
    @driver.navigate.to(REESTR_URL)
    wait_for_vin_tab
    human_pause
    random_mouse_moves

    select_search_by_vin
    human_pause
    fill_vin(@vin)
    submit_search

    wait_results_loaded
    parse_results
  ensure
    @driver&.quit
  end

  private

  attr_accessor :result

  def build_driver(headless:)
    SeleniumBuilderExtraScripts.new(headless: headless).call
  end

  def wait_for_vin_tab
    @wait.until { find_vin_tab }
  end

  def human_pause(min=0.4, max=1.2)
    sleep rand(min..max)
  end

  def random_mouse_moves
    3.times do
      x = rand(0..300)
      y = rand(0..300)
      @driver.action.move_by(x, y).perform
      sleep rand(0.05..0.2)
    end
  end

  def select_search_by_vin
    tab = find_vin_tab
    human_click(tab) if tab.present?
  end

  def find_vin_tab
    @driver.find_element(xpath: "//*[contains(text(),'По информации о предмете залога')]")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end

  def find_vin_input
    @driver.find_element(id: "vehicleProperty.vin")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end

  def human_click(element)
    actions = @driver.action
    actions.move_to(element)
    sleep rand(0.2..0.6)
    actions.click
    actions.perform
    sleep rand(0.3..0.8)
  end

  def fill_vin(vin)
    input = @wait.until { find_vin_input }
    input.clear
    input.send_keys(vin)
  end

  def submit_search
    active = @driver.switch_to.active_element
    active.send_keys(:enter)
  end

  def wait_results_loaded
    @wait.until { find_result.present? }
  rescue Selenium::WebDriver::Error::TimeoutError => e
    warn "Результаты не появились. Возможно капча или нет данных."
    Sentry.capture_exception(e, extra: { service: 'ReestrZalogov', vin: @vin })
    raise e
  end

  def find_result
    @driver.find_elements(css: ".table-search, .search-error-label").first
  end

  def empty_result
    { raw_data: result.attribute("outerHTML") }
  end

  def handle_filled_result
    row = result.find_elements(css: "tbody tr").first

    tds = row&.find_elements(css: "td")
    return empty_result if tds.blank?

    {
      raw_data: result.attribute("outerHTML"),
      parsed_data: {
        index: tds[0]&.text&.strip,
        registration_date: tds[1]&.text&.strip,
        notification_number: extract_notification_number(tds[2]),
        property: tds[3]&.text&.strip,
        pledgor: tds[4]&.text&.strip,
        pledgee: tds[5]&.text&.strip
      }
    }.compact
  end

  def extract_notification_number(cell)
    cell.find_element(css: ".notification")&.text&.strip
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end

  def parse_results
    self.result = find_result

    if result.text.include?("результатов не найдено")
      empty_result
    else
      handle_filled_result
    end
  end
end
