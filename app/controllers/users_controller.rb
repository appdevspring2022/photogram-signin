class UsersController < ApplicationController
  def authenticate
    # get user name and password from user input
    un = params.fetch("input_username")
    pw = params.fetch("input_password")

    # check if the user exist in the database
    user = User.where({ :username => un }).at(0)

    # if no, go back to sign in page
    if user == nil
      redirect_to("/user_sign_in", { :alert => "No one by this name round these parts." })
      # if yes, check if password matches
    else
      # if yes, go to the homepage
      if user.authenticate(pw)
        session.store(:user_id, user.id)
        redirect_to("/", {:notice=>"Welcome back, "+user.username+"!"})
        # if no, go back to sign page
      else
        redirect_to("/user_sign_in", { :alert => "Password is wrong." })
      end
    end
  end

  def signin
    render({ :template => "users/sign_in.html.erb" })
  end

  def toast_cookies
    reset_session
    redirect_to("/", :notice => "See you later!")
  end

  def register
    render({ :template => "users/sign_up.html.erb" })
  end

  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username + "!" })
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save

    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end
end
