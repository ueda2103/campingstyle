class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @follow = Relationship.new(followed_id: current_user.id, follower_id: params[:user_id])
    @follow.save
    redirect_back fallback_location: root_path
  end

  def destroy
    Relationship.find_by(followed_id: current_user.id, follower_id: params[:user_id]).destroy
    redirect_back fallback_location: root_path
  end
end
