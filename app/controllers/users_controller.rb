class UsersController < ApplicationController
  def index
    users = User.all.select(:id, :first_name, :last_name, :email)
    render :json => users
  end

  def show
    user = User.where(id: params[:id]).select(:id, :first_name, :last_name, :email).first
    render json: user
  end
end
