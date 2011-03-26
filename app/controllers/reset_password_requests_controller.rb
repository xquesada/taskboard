class ResetPasswordRequestsController < ApplicationController
  layout "reset_password"


def new
  
end

def create
  # figure out if user exists
  user = User.find_by_email params[:email]
  # if exists, reset hash and send e-mail
  user.send_password_reset_information if user.present?
  # note: if user does not exist, view that says "password request sent" is displayed anyways for security reasons!
  
end
  
def edit
  @user = User.find_by_perishable_token params[:id]
end

def update
  @user = User.find_by_perishable_token params[:id]
  @user.password = params[:user][:password]
  @user.password_confirmation = params[:user][:password_confirmation]
  if !@user.save
    flash[:error] = "Passwords do not match."
    render :edit
  else
    flash[:notice] = "Password successfully reset"
    redirect_to root_path
  end
  
end

  
end