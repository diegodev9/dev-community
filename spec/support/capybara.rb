require 'capybara/rspec' # new
require 'selenium/webdriver' #new

RSpec.configure do |config|
  Capybara.register_driver :chrome do |app| # new
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :chrome
  Capybara.default_driver = :chrome

  def options
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--start-maximized")
    options
  end
end
