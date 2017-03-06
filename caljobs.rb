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
      # Terms of Agreement
      visit 'https://www.caljobs.ca.gov/register.asp?t=ind&action=&plang=E'

      find('#ctl00_Main_content_ucPrivacyAgreement_btnAgree').click

      # Page 1 Demographics

      page.should have_content('Login Information')

      username = 'job_bot_9000'
      fill_in('ctl00_Main_content_ucLogin_txtUsername', with: username)

      password_field_id = 'ctl00_Main_content_ucLogin_ucPassword_txtPwd'

      page.execute_script("$('##{password_field_id}').attr('onkeyup', '')")

      password = 'CalJobs1@'
      fill_in(password_field_id, with: password)

      expect(find('#ctl00_Main_content_ucLogin_ucPassword_txtPwd').value).to eq password

      fill_in('ctl00_Main_content_ucLogin_ucPassword_txtPwdConfirm', with: password)

      select("What is your mother's maiden name?", from: 'ctl00_Main_content_ucLogin_ddlSecurityQuestion')
      fill_in('ctl00_Main_content_ucLogin_txtSecurityQuestionResponse', with: 'Momma')

      ssn = '1100113456'
      fill_in('ctl00_Main_content_ucSSN_txtSSN', with: ssn)
      fill_in('ctl00_Main_content_ucSSN_txtSSNReenter', with: ssn)

      zip = '12345'
      fill_in('ctl00_Main_content_txtZip', with: zip)

      choose('ctl00_Main_content_radAuthorizedToWork_0')

      email = 'fake_email_r3874@gmail.com'
      fill_in('ctl00_Main_content_ucEmailTextBox_txtEmail', with: email)

      fill_in('ctl00_Main_content_ucEmailTextBox_txtEmailConfirm', with: email)

      dob = '01/01/1991'
      fill_in('ctl00_Main_content_ucRegDemographics_txtDOB', with: dob)

      choose('ctl00_Main_content_ucRegDemographics_rblGender_1')

      next_button = find('#ctl00_Main_content_btnNext')

      next_button.should_not have_css('disabled')

      select('Yes', from: 'ctl00_Main_content_ucRegDemographics_ddlDraftStatus')

      next_button.should_not have_css('disabled')

      next_button.click

      # Page 2 Full Name
      page.should have_css('#ctl00_Main_content_pnContact')

      first_name = 'Sandie'
      last_name = 'Go'
      fill_in('ctl00_Main_content_ucName_txtFirstName', with: first_name)
      fill_in('ctl00_Main_content_ucName_txtLastName', with: last_name)

      next_button.click

      # Page 3 Address
      page.should have_css('#ctl00_Main_content_ucAddress_pnAddressPrimary')

      address_line_1 = '1234 Fake St'
      fill_in('ctl00_Main_content_ucAddress_txtAddress1', with: address_line_1)
      check('Use residential address')

      next_button.should_not have_css('disabled')
      next_button.click

      pause
    end

    def pause
      $stderr.write 'Press enter to continue'
      $stdin.gets
    end

    def wait_for_ajax
      Timeout.timeout(Capybara.default_max_wait_time) do
        loop until finished_all_ajax_requests?
      end
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery.active').zero?
    end
  end
end

Caljobs::Register.new.run
