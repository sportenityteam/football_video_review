class Admin::UsersController < ApplicationController

  before_action :set_user, :only => [:edit, :update, :show, :destroy]

  def index
    #@users = User.is_reviewer
    page = 10
    if params[:per_page].present?
      page = params[:per_page]
    end
    @users = User.where(:user_type => User::USER_TYPES[params[:type]]).page(params[:page]).per(page)
    if params[:search].present?
      @users = @users.search_items(params[:search])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.user_type = 2
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path(:type => "reviewer"), notice: 'Reviewer was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def show
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        if @user.is_reviewer?
          format.html { redirect_to admin_users_path(:type => "reviewer"), notice: 'Reviewer was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        elsif @user.is_user?
          format.html { redirect_to admin_users_path(:type => "user"), notice: 'Reviewer was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        end          
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user.is_reviewer?
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_path(:type => "reviewer"), notice: 'Reviewer was successfully destroyed.' }
        format.json { head :no_content }
      end
    elsif @user.is_user?
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_path(:type => "user"), notice: 'Reviewer was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :gender, :date_of_birth, :address, :zipcode, :phone_number, :user_type, :current_club, :avatar, :description,:position)
    end
end