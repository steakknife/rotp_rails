class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :start_enroll, :enroll, :finish_enroll, :start_unenroll, :unenroll, :start_validate, :validate]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end


  # GET /users/1/enroll
  def start_enroll
    respond_to do |format|
      if @user.rotp_enrolled?
        format.html { redirect_to @user, notice: 'User already entrolled for Google Auth' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      else
        format.html { }
        format.json { head :no_content }
      end
    end
  end


  # POST /users/1/enroll
  def enroll
    respond_to do |format|
      if @user.rotp_enroll
        format.html { redirect_to finish_enroll_user_path(@user), notice: 'User was successfully enrolled for Google Auth.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish_enroll
  end

  # GET /users/1/unenroll
  def start_unenroll
    unless @user.rotp_enrolled?
      redirect_to @user, notice: 'User already unenrolled from Google Auth'
    end
  end

  # POST /users/1/unenroll
  # DELETE /users/1/enroll
  def unenroll
    respond_to do |format|
      if @user.rotp_enrolled?
        format.html {
          @user.rotp_unenroll!
          redirect_to @user, notice: 'User unenrolled from Google Auth'
        }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: 'User already unenrolled from Google Auth' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/validate
  def start_validate
    redirect_to enroll_user_path(@user), notice: 'User must be enrolled in Google Auth' unless @user.rotp_enrolled?
  end

  # POST /users/1/validate
  def validate
    respond_to do |format|
      if @user.rotp_enrolled?
        if @user.rotp_valid?(user_params[:rotp_code])
          format.html { redirect_to @user, flash: { success: 'Code validated' } }
          format.json { head :no_content }
        else
          format.html { redirect_to validate_user_path(@user), flash: { error: 'Code was invalid' } }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to enroll_user_path(@user), flash: { error: 'User must be enrolled in Google Auth' } }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :rotp_code)
    end
end
