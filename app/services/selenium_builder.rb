# frozen_string_literal: true

class SeleniumBuilder
  def initialize(headless: true)
    @headless = headless
  end

  def call
    build_driver
  end

  private

  def build_driver
    options = Selenium::WebDriver::Chrome::Options.new

    options.add_argument("--window-size=1400,900")
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.exclude_switches << "enable-automation"

    options.add_argument("--headless=new") if @headless

    options.add_argument("user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")

    driver = Selenium::WebDriver.for(:chrome, options: options)

    # Убираем navigator.webdriver
    driver.execute_cdp(
      "Page.addScriptToEvaluateOnNewDocument",
      source: <<~JS
        Object.defineProperty(navigator, 'webdriver', {
          get: () => undefined
        });
      JS
    )

    driver
  end
end
