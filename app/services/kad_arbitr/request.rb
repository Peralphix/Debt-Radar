# frozen_string_literal: true

class KadArbitr::Request
  KAD_URL = "https://kad.arbitr.ru/".freeze

  def initialize(inn:, headless: true, timeout: 20)
    @inn = inn.to_s.strip
    @timeout = timeout
    @driver = build_driver(headless: headless)
    @wait = Selenium::WebDriver::Wait.new(timeout: @timeout)
  end

  def call
    @driver.navigate.to(KAD_URL)
    wait_for_search_ui
    fill_search(@inn)
    submit_search
    wait_results_loaded
    parse_response
    result
  ensure
    @driver&.quit
  end

  private

  attr_accessor :table, :result

  def build_driver(headless:)
    SeleniumBuilder.new(headless: headless).call
  end

  def wait_for_search_ui
    begin
      @wait.until { find_search_input }
    rescue Selenium::WebDriver::Error::TimeoutError => e
      warn "Не вижу поисковую форму. Возможно, включилась антибот-проверка/капча."
      Sentry.capture_exception(e, extra: { service: 'KadArbitr', inn: @inn })
      raise e
    end
  end

  def find_search_input
    @driver.find_element(css: "textarea[placeholder*='ИНН']")
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end

  def fill_search(text)
    input = @wait.until { find_search_input }
    input.clear
    input.send_keys(text)
  end

  def submit_search
    active = @driver.switch_to.active_element
    active.send_keys(:enter)
  end

  def wait_results_loaded
    @wait.until do
      # @driver.find_elements(css: "table#b-cases tr").any? || find_no_results_section.present?
      @driver.find_elements(css: "table#b-cases tr").any?
    end
  end

  def find_no_results_section
    @driver.find_element(xpath: "//*[contains(text(),'Нет результатов')]")
  rescue
    nil
  end

  def parse_response
    self.table = @driver.find_element(css: "table#b-cases")
    self.result = { parsed_data: parse_result, raw_data: table.attribute("outerHTML") }.compact_blank
  rescue Selenium::WebDriver::Error::NoSuchElementError
    self.result = { raw_data: find_no_results_section.attribute("outerHTML") }
    nil
  end

  def parse_result
    rows = table.find_elements(css: "tr")
    results = []

    rows.each do |tr|
      tds = tr.find_elements(css: "td")
      next if tds.size < 3

      date, case_number = safe_text(tds[0]).split("\n")
      case_link = find_case_link(tr)

      results.push(
        {
          date:,
          case_number:,
          judge: safe_text(tds[1]),
          plaintiff: safe_text(tds[2]),
          defendant: safe_text(tds[3]),
          url: case_link&.attribute("href")
        }
      )
    end

    results
  end

  def find_case_link(tr)
    card_link = tr.find_elements(css: "a").find { |a| a.attribute("href")&.include?("/Card/") }
    return card_link if card_link

    tr.find_elements(css: "a").first
  end

  def safe_text(el)
    el&.text&.strip
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { service: 'KadArbitr', method: 'safe_text' })
    nil
  end
end
