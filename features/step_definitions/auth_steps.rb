## Step Definitions for Facebook Login and Sign Up ##

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    new_user = User.create(user)
    new_user.save
  end
end


Given /^I am logged in$/ do  
  visit "/auth/facebook?type=login"
end  

Given /^my authentication fails$/ do
  visit "/auth/failure"
end
