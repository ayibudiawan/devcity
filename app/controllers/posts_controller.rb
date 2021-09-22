class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to timelines_path, notice: "Posts successfully createds" }
      else
        format.html { redirect_to timelines_path, alert: "Description can't be blank" }
      end
    end
  end

  private
    def post_params
      params.require(:post).permit(:description).merge(:user_id => current_user.id)
    end
end
