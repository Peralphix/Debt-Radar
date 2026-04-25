# frozen_string_literal: true

class SeleniumBuilderExtraScripts
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
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    if @headless
      options.add_argument("--headless=new")
      options.add_argument("--disable-gpu")
    else
      options.add_argument("--start-maximized")
    end

    options.add_argument("--disable-blink-features=AutomationControlled")
    options.exclude_switches << "enable-automation"

    options.add_argument("user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36")

    driver = Selenium::WebDriver.for(:chrome, options: options)

    driver.execute_cdp(
      "Page.addScriptToEvaluateOnNewDocument",
      source: <<~JS
      Object.defineProperty(navigator, 'webdriver', {
        get: () => undefined
      });

      window.chrome = {
        runtime: {}
      };

      Object.defineProperty(navigator, 'plugins', {
        get: () => [1,2,3,4,5]
      });

      Object.defineProperty(navigator, 'languages', {
        get: () => ['ru-RU', 'ru']
      });
    JS
  )

    driver
  end
end
