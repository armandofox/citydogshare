class UsersController < ApplicationController
  before_filter :current_user

  def show
    if User.exists?(params[:id]) == false
      flash[:notice] = "The user you entered does not exist."
      redirect_to @current_user
    else
      id = params[:id]
      @user = User.find(id)
      @own_profile = @user == @current_user
      @starred_dogs = @current_user && @current_user.starred_dogs ? @current_user.starred_dogs : []
      render 'show'
    end
  end

  def edit
    flash[:notice] = "All information added here will be visible to other members."
    if @current_user.dogs.empty?
      flash[:notice] = "Please update your zipcode to add a dog. All information added here will be visible to other members."
    end
    @user = User.exists?(params[:id]) ? User.find(params[:id]) : nil
    if !(@is_admin or (@user != nil and @user == @current_user))
      flash[:notice] = "You may only edit your own profile."
      redirect_to @current_user
    elsif params[:user] != nil and @user.update_attributes(user_params)
      @user.dogs.each do |dog|
        dog.geocode
        dog.save
      end
      flash[:notice] = "Profile successfully updated."
      redirect_to @user
    else
      flash[:notice] = @user.errors.messages unless not @user.errors.any?
      render 'edit'
    end
  end
  
  def info
    id = params[:id]
    if !User.exists?(id)
      render :json => { "success" => false, "message" => "User not found"}
    else
      @user = User.find(id)
      render :json => {
        "success" => true,
        "message" => "User found",
        "user" => @user.to_json
      }
    end
  end

  # This destroys the user and signs them out, taking them to the home page
  def destroy
    @current_user.destroy
    session[:user_id] = nil
    redirect_to root_path()
  end

  def stars
    if !@current_user.nil? and @current_user.id != params[:id].to_i
      redirect_to(stars_user_path(@current_user))
    end
    @starred_dogs = @current_user && @current_user.starred_dogs ? @current_user.starred_dogs : []
  end
  
  def dogs
    if !@current_user.nil? and @current_user.id != params[:id].to_i
      redirect_to(dogs_user_path(@current_user.id))
    end
    @dogs = User.find_by_id(params[:id]).dogs
    @starred_dogs = @current_user && @current_user.starred_dogs ? @current_user.starred_dogs : []
  end
  
  # def toggle_pro
  #   if @user.is_pro?
  #     @user.set_pro(false)
  #   else
  #     @user.set_pro(true)
  #     #Make sure it refreshes the page? 
  #   end
  # end
  
  def toggle
    @user = User.find(params[:id])
    @starred_dogs = @current_user && @current_user.starred_dogs ? @current_user.starred_dogs : []
    if @user.is_pro?
      @user.set_pro(false)
    else
      @user.set_pro(true)
    end
    render 'show'
  end
  
  def pro
    redirect_to("http://city-dog-share-calendar.herokuapp.com/")
    
  end

  private
  def user_params
    if params[:user]
      params.require(:user).permit(:first_name, :last_name, :location, :gender, :image, :status, :phone_number, :email, :availability, :description, :address, :zipcode, :city, :country)
    end
  end
end
