# Hubstaff Rails - Integrate Hubstaff API Into Your Rails 5 App

**[Watch how this app
works](https://www.youtube.com/watch?v=-5fRjR_V5do&feature=youtu.be)**

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

## Using the Hubstaff Ruby API client

**Step 1:** Add `hubstaff-ruby` to your Gemfile and `bundle install`.

```ruby
#Gemfile

gem "hubstaff-ruby", git: "https://github.com/hookengine/hubstaff-ruby.git"
```
**Step 2:** Get your [HUBSTAFF_APP_TOKEN](https://developer.hubstaff.com/my_apps), and it to your `.env` file.

**Step 3:** Require files from the `hubstaff-ruby` gem in your Rails environment; before you initialize
the Rails application. And then load your environment variables.

```ruby
#environment.rb
...
require "hubstaff"
Dotenv.load(".env")
Rails.application.initialize!
```

**Step 4:** Define your routes to handle authentication and
retrieving data from Hubstaff.

```ruby
#routes.rb
get "/pages/integration" => "pages#integration" #hubstaff email/password form
post "/pages/integration" => "pages#integration", as: :integration #process email/password

get "/pages/screenshots" => "pages#screenshots", as: :screenshots #display screenshots
get "/pages/activities" => "pages#activities", as: :activities #display activities
```
**Step 5:** Define actions in your pages controller.

```ruby
#pages_controller.rb

include Hubstaff
HUBSTAFF_CLIENT = Hubstaff::Client.new(ENV["HUBSTAFF_APP_TOKEN"])

def integration
  if params[:hubstaff_email].present? && params[:hubstaff_password].present? #check if hubstaff email/password is submitted and grab it on post request
    @hubstaff_email = params[:hubstaff_email]
    @hubstaff_password = params[:hubstaff_password]
    authenticate_and_save_auth_token(@hubstaff_email,@hubstaff_password)
    #then save
authenticate and save
    redirect_to root_path, notice: "Successfully Connected To Hubstaff"
  else
    render :integration, alert: "Unable To Connect To Hubstaff"
  end
end

def authenticate_and_save_auth_token(email,password)
  client_user = User.find_by_email(current_user.email)
  HUBSTAFF_CLIENT.authenticate(@hubstaff_email,@hubstaff_password)
  client_user.hubstaff_auth_token = HUBSTAFF_CLIENT.auth_token #you'll need a migration to add hubstaff_auth_token to User model
  client_user.save!
end

def screenshots #retrieve screenshots for display in your app
  if current_user.hubstaff_auth_token.present?
    HUBSTAFF_CLIENT.auth_token = current_user.hubstaff_auth_token
    @hubstaff_screenshots = HUBSTAFF_CLIENT.screenshots("2016-05-22","2016-05-24", projects: "112761")
    render :screenshots
  else
    render :integration, alert: "Please Connect To Hubstaff"
  end
end

def activities #retrieve activities for display in your app
  if current_user.hubstaff_auth_token.present?
    HUBSTAFF_CLIENT.auth_token = current_user.hubstaff_auth_token
    @hubstaff_activities = HUBSTAFF_CLIENT.activities("2016-05-22","2016-05-24",users: "61188")
    render :activities
  else
    render :integration, alert: "Please Connect To Hubstaff"
  end
end
end
```
**Step 6:[Your Turn]** Create forms that your users can pass the
required parameters into, so that they retrieve & display the exact data they
want.

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
