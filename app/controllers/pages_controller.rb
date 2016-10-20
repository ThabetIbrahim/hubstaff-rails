class PagesController < ApplicationController
  include Clearance::Controller
  include Hubstaff
  before_filter :require_login

  HUBSTAFF_CLIENT = Hubstaff::Client.new(ENV["HUBSTAFF_APP_TOKEN"])

  def show
    current_user
    render :home
  end

  def integration
    if params[:hubstaff_email].present? && params[:hubstaff_password].present? #check if hubstaff email/password is passed
      @hubstaff_email = params[:hubstaff_email]
      @hubstaff_password = params[:hubstaff_password]
      authenticate_and_save_auth_token(@hubstaff_email,@hubstaff_password)
      redirect_to root_path, notice: "Successfully Connected To Hubstaff"
    else
      render :integration, alert: "Unable To Connect To Hubstaff"
    end
  end

  def authenticate_and_save_auth_token(email,password)
    client_user = User.find_by_email(current_user.email)
    HUBSTAFF_CLIENT.authenticate(@hubstaff_email,@hubstaff_password)
    client_user.hubstaff_auth_token = HUBSTAFF_CLIENT.auth_token #created a migration to add hubstaff_auth_token to User model
    client_user.save!
  end

  def screenshots
    if current_user.hubstaff_auth_token.present?
      HUBSTAFF_CLIENT.auth_token = current_user.hubstaff_auth_token
      @hubstaff_screenshots = HUBSTAFF_CLIENT.screenshots("2016-09-29","2016-10-01", projects: "112761")
      render :screenshots
    else
      render :integration, alert: "Please Connect To Hubstaff"
    end
  end

  def activities
    if current_user.hubstaff_auth_token.present?
      HUBSTAFF_CLIENT.auth_token = current_user.hubstaff_auth_token
      @hubstaff_activities = HUBSTAFF_CLIENT.activities("2016-09-29","2016-10-01", users: "61188")
      render :activities
    else
      render :integration, alert: "Please Connect To Hubstaff"
    end
  end
end
