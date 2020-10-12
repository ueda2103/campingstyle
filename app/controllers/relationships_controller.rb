class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @follower = User.find(params[:user_id])
    @relationship = Relationship.new(followed_id: current_user.id, follower_id: @follower.id)
    @relationship.save
  end

  def destroy
    @follower = User.find(params[:user_id])
    @relationship = Relationship.find_by(followed_id: current_user.id, follower_id: @follower.id)
    @relationship.destroy
  end
end
