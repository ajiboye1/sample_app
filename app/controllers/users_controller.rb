class UsersController < ApplicationController
    before_filter :authenticate, :except => [:show, :new, :create]
    before_filter :correct_user, :only => [:edit, :update]
    before_filter :admin_user, :only => :destroy
    before_filter :already_signed_in, :only => [:new, :create]
  
    def index
      @title = "All users"
      @users = User.paginate(:page => params[:page])
    end

  def show
     @user = User.find(params[:id])
     @title = @user.name
  end

  def new
     @user = User.new
     @title = "Sign up"
  end

  def create
     @user = User.new(params[:user])
     if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      #Handle a successful save
      redirect_to @user
     else 
       @title = "Sign up"
       @user.password = nil
       @user.password_confirmation = nil
       render 'new'
     end
  end

   def edit
     #@user = User.find(params[:id])
     @title = "Edit user"
   end

   def update
     @user = User.find(params[:id])
     if @user.update_attributes(params[:user])
       flash[:success] = "Profile updated."
        redirect_to @user
     else
       @title = "Edit user"
       render 'edit'
     end
   end

    def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end

    def show
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(:page => params[:page])
      @title = @user.name
    end

    def following
       show_follow(:following)
     # @title = "Following"
     # @user = User.find(params[:id])
     # @users = @user.following.paginate(:page => params[:page])
      #render 'show_follow'
    end

    def followers
      show_follow(:followers)
     # @title = "Followers"
      #@user = User.find(params[:id])
      #@users = @user.followers.paginate(:page => params[:page])
      #render 'show_follow'
    end

     
   private 
     def show_follow(action)
       @title = action.to_s.capitalize
       @user = User.find(params[:id])
       @users = @user.send(action).paginate(:page => params[:page])
       render 'show_follow'
     end
    #def authenticate
      #deny_access unless signed_in?
    #end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
       redirect_to(root_path) unless current_user.admin?
    end

    def already_signed_in
      redirect_to(root_path) if signed_in?
    end
end
