def login_user(user)
  visit new_user_session_path
  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password
  click_button "Sign in"
end

def register(username, password, options = {})
  visit new_user_registration_path
  fill_in "Email", :with => username
  fill_in "Password", :with => password
  fill_in "Confirm password", :with => password
  if options[:invite_code]
    fill_in "Invite code", :with => options[:invite_code]
  end
  click_button "Sign up"
end

def invite_code(options = {})
  InviteCode.create(options).token
end

def soap
  save_and_open_page
end

## fill_in_fields :user_email   => 'bob@smith.com'
## fill_in_fields :user, :email => 'bob@smith.com'
#def fill_in_fields *args
#  raise 'Too many arguments!' if args.size > 2
#  prefix = args.first.is_a?(Hash) ? '' : "#{ args.shift }_"
#  args.last.each { |field, value| fill_in "#{ prefix }#{ field }", :with => value }
#end

#def reload_page
#  visit current_path
#end

## Apparently, Rack Test and Capybara don't get along when it comes to cookies.
#def fetch_cookies
#  raise 'unsupported driver, use rack::test' unless Capybara.current_session.driver.is_a?(Capybara::Driver::RackTest)

#  driver   = Capybara.current_session.driver
#  session  = driver.current_session.instance_variable_get '@rack_mock_session'
#  @cookies = session.cookie_jar.instance_variable_get '@cookies'
#end

#def should_be_on path
#  current_path.should == path.split('?').first #ignore query string
#end

#def should_not_be_on path
#  current_path.should_not == path
#end

#def dom_id obj
#  "#{ obj.class.model_name.underscore }_#{ obj.id }".downcase
#end

#def use_javascript
#  Capybara.current_driver = :selenium
#end

