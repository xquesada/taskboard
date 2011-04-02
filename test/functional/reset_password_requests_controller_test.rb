require File.dirname(__FILE__) + '/../test_helper'

class ResetPasswordRequestsControllerTest < ActionController::TestCase
  context "Permissions" do
     should_require_no_user_on [:new, :create, :edit, :update]
  end
 
  context "Users Routes" do
    # Test that route exists
    should_route :get, "/reset_password_requests/new", :action => :new
  end
 
  # ----------------------------------------------------------------------------------------------------------------
  # Not logged User
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an unlogged user" do
    context "and do GET to :new" do
      setup do
        get :new
      end
      should_render_template :new
    end
 
  # TODO: POST method could not be tested - need help
    #context "and do POST to :create" do
    #  context "with a valid user's e-mail" do
    #    setup do
    #      @testuser = Factory(:user)
    #      post :create, :email => @testuser.email
    #    end
    #    # TODO We are missing a way to assert that the method send_password_reset_information was called
    #    should_render_template :create
    #  end
    #  
    #  context "with an invalid e-mail" do
    #    setup do
    #      post :create, :email => "test@something.com"
    #    end
    #    
    #  end
    #end
  end
  
  context "If I am a logged in user" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
    end
    context "and do GET to :new" do
      setup do
        get :new
      end
      should_set_the_flash_to("Please Logout")
      should_redirect_to("account url"){ account_url }
    end
  end
  

  
end


