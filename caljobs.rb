require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

include RSpec::Matchers

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.google.com'
Capybara.default_max_wait_time = 10

module Caljobs
  class Register
    include Capybara::DSL
    def run
      visit 'https://www.caljobs.ca.gov/register.asp?t=ind&action=&plang=E'

      find('#ctl00_Main_content_ucPrivacyAgreement_btnAgree').click

      page.should have_content('Login Information')

      username = 'job_bot_9000'
      fill_in('ctl00_Main_content_ucLogin_txtUsername', with: username)

      password = 'CalJobs1@'
      fill_in('ctl00_Main_content_ucLogin_ucPassword_txtPwd', with: password)
      fill_in('ctl00_Main_content_ucLogin_ucPassword_txtPwdConfirm', with: password)

      save_and_open_screenshot
    end
  end
end

Caljobs::Register.new.run
