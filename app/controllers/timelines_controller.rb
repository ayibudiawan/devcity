class TimelinesController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    @user = current_user
    if params[:email].present?
      user = User.find_by_email(params[:email])
      @user = user if user.present?
    end
    user_ids = Activity.get_updates(current_user, "web")
    @timelines = Post.where("user_id in (?)", user_ids).includes(:user).order("created_at DESC").page(params[:page])
    @posts = Post.where(:user_id =>  @user.id).includes(:user).order("created_at DESC").page(params[:page])
    @users = User.where("id in (?)", @user.friends.pluck(:target_id))
    @search = params[:search].try(:strip)
    if @search.present?
      @users = User.where("fullname ilike ? OR username ilike ? OR email ilike ? AND id != ?", "%#{@search}%", "%#{@search}%", "%#{@search}%", current_user.id).order("created_at DESC").page(params[:page])
      @posts = Post.includes(:user).where("description ilike ?", "%#{@search}%").order("created_at DESC").page(params[:page])
    end
  end

  def activities
    if ["unfriend", "unsubscribe", "unblock"].include?(params[:act])
      activities = {}
      activities["status"] = false
      act = Activity.where("requestor_id = ? and target_id = ?", current_user.id, params[:target]).first
      if act.present?
        activities["status"] = true
        if params[:act].eql?("unfriend")
          act.update_attributes(:is_friend => false)
        elsif params[:act].eql?("unsubscribe")
          act.update_attributes(:is_subscribe => false)
        else
          act.update_attributes(:is_block => false)
        end
      else
        activities["message"] = "Something went wrong"
      end
    else
      if params[:act].eql?("add_friend")
        activities = Activity.friend([current_user.email, params[:target]], "add_friend")
      else
        activities = Activity.act(current_user.email, params[:target], params[:act])
      end
    end
    respond_to do |format|
      if activities["status"]
        format.html { redirect_back(fallback_location: root_path, notice: "Successfully #{params[:act].humanize.downcase}") }
      else
        format.html { redirect_back(fallback_location: root_path, alert: activities["message"]) }
      end
    end
  end
end
