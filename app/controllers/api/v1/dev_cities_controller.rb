class Api::V1::DevCitiesController < API::BaseController
  api :POST, '/add_friend', 'Add friend from two array of users'
  formats ['json']
  error 400, "Bad requestss"
  param :friends, Array, :desc => "Array of two emails", :required => true
  def add_friend
    add_friend = Activity.friend(params[:friends], "add_friend")
    if add_friend["status"]
      render json: {success: true}, status: 200
    else
      render json: {success: false, :message => add_friend["message"]}, status: 400
    end
  end

  api :GET, '/friend_list', 'Get friend list by email'
  formats ['json']
  error 400, "Bad requests"
  param :email, String, :desc => "String email", :required => true
  def friend_list
    friend_list = User.friend_list(params[:email])
    if friend_list["status"]
      render json: {success: true, friends: friend_list["friends"], count: friend_list["count"]}, status: 200
    else
      render json: {success: false, :message => friend_list["message"]}, status: 400
    end
  end

  api :POST, '/common_friend', 'Get friend in common from two array of users'
  formats ['json']
  error 400, "Bad requests"
  param :friends, Array, :desc => "Array of two emails", :required => true
  def common_friend
    common_friend = Activity.friend(params[:friends], "common_friend")
    if common_friend["status"]
      render json: {success: true, friends: common_friend["friends"], count: common_friend["count"]}, status: 200
    else
      render json: {success: false, :message => common_friend["message"]}, status: 400
    end
  end

  api :POST, '/subscribe', 'Subscribe another users'
  formats ['json']
  error 400, "Bad requests"
  param :requestor, String, :desc => "User who request a subscribe", :required => true
  param :target, String, :desc => "Target user that will be subscribe", :required => true
  def subscribe
    subscribe = Activity.act(params[:requestor], params[:target], "subscribe")
    if subscribe["status"]
      render json: {success: true}, status: 200
    else
      render json: {success: false, :message => subscribe["message"]}, status: 400
    end
  end

  api :POST, '/block', 'Block another users'
  formats ['json']
  error 400, "Bad requests"
  param :requestor, String, :desc => "User who request a block", :required => true
  param :target, String, :desc => "Target user that will be block", :required => true
  def block
    block = Activity.act(params[:requestor], params[:target], "block")
    if block["status"]
      render json: {success: true}, status: 200
    else
      render json: {success: false, :message => block["message"]}, status: 400
    end
  end

  api :POST, '/receive_updates', 'List users who will get updates'
  formats ['json']
  error 400, "Bad requests"
  param :sender, String, :desc => "User who trigger the event", :required => true
  param :text, String, :desc => "Text that will be send", :required => true
  def receive_updates
    receive_updates = Activity.receive_updates(params[:sender], params[:text])
    if receive_updates["status"]
      render json: {success: true, recipients: receive_updates["recipients"]}, status: 200
    else
      render json: {success: false, :message => receive_updates["message"]}, status: 400
    end
  end
end
