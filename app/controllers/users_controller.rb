class UsersController < ApplicationController
  def index
    users = User.all.select(:id, :first_name, :last_name, :email)
    render :json => users
  end

  def show
    if user = User.where(id: params[:id]).select(:id, :first_name, :last_name, :email).first
      render json: user
    else
      render text: "Unknown User", status: 404
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: User.where(id: user.id).select(:id, :first_name, :last_name, :email).first
    else
      render text: "Invalid Params", status: 400
    end
  end

  private

  def user_params
    params[:user][:social_security_number] = params[:user][:social_security_number].delete("-")
    params.require(:user).permit(:first_name, :last_name, :email, :social_security_number)
  end
end
