require 'spec_helper'

describe SessionsController, :type => :controller do

  describe 'logging in as an existing user' do
    before (:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
    end 

    it 'should find the user' do
      User.should_receive(:find_by_uid).with(request.env["omniauth.auth"][:uid])
      visit "/auth/facebook?type=login"
    end 

    it 'should update their credentials' do
      user1 = User.create(:uid => "12345", :name => "Batman")
      User.should_receive(:find_by_uid).with(request.env["omniauth.auth"][:uid]).and_return(user1)
      visit "/auth/facebook?type=login"
      user1.oauth_token.should == request.env["omniauth.auth"][:credentials][:token]
      user1.oauth_expires_at.should == request.env["omniauth.auth"][:credentials][:expires_at]
    end 

    it 'should redirect to the user profile page' do 
      user1 = User.create(:uid => "12345")
      User.should_receive(:find_by_uid).with(request.env["omniauth.auth"][:uid]).and_return(user1)
      visit "/auth/facebook?type=login"
      response.should render_template("users/show")
    end

  end
  describe 'logging in as a new user' do
    before (:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
    end 

    it 'should try to find the user' do
      User.should_receive(:find_by_uid).with(request.env["omniauth.auth"][:uid])
      visit "/auth/facebook?type=login"
    end 

    it 'should redirect to the home page' do
       visit "/auth/facebook?type=login"
       response.should render_template("/")
    end

  end

  describe 'authentication fails' do 
    it 'should redirect to the home page' do
       request.env["omniauth.auth"] = :invalid_credentials
       visit "/auth/facebook?type=login"
       response.should render_template("/")
    end
  end
  
  describe 'signing out' do
    it 'should redirect to the home page' do
       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
       visit "/auth/facebook?type=login"
       visit "/signout"
       response.should render_template("/")
    end
  end
end
    
