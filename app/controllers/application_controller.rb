class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions

  around_action :catch_halt

  def current_user
    @current_user ||= User.find_by_email(user_data['email'])
  end

  def render(*args)
    super
    throw :halt
  end

  rescue_from CanCan::AccessDenied do |_exception|
    catch :halt do
      render_unauthorized!
    end
  end

  protected

  def catch_halt
    catch :halt do
      yield
    end
  end

  def render_unauthorized!(error = 'unauthorized')
    render(json: { 'error': error }, status: 403)
  end

  def check_token!
    response = user_data
    permitted_users = (ENV['PERMITTED_USERS'] || '').split(',')
    render_unauthorized! unless permitted_users.include?(response['email']) || response['email'].end_with?('@berniesanders.com')
  end

  def user_data
    response = RestClient.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json', Authorization: request.headers['Authorization'])
    @user_data ||= JSON.parse(response)
  rescue
    render_unauthorized!('bad_token')
  end
end
