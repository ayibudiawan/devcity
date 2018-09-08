class Activity < ApplicationRecord
  belongs_to :requestor, :class_name => 'User', :foreign_key => 'requestor_id'
  belongs_to :target, :class_name => 'User', :foreign_key => 'target_id'

  validates_presence_of :requestor_id, :target_id
  validates :requestor_id, :uniqueness => {:scope => [:target_id]}

  def self.friend(friends, activity)
    response = {"status" => false, "message" => ""}
    if !friends.class.eql?(Array) || friends.try(:count) != 2
      response["message"] = "Parameter must be array and consist of 2 email"
    else
      users = User.where("email in (?)", friends)
      empty_users = friends - users.pluck(:email)
      if empty_users.present?
        response["message"] = "User with email #{empty_users.join(',')} not found"
      else
        user_1 = User.find_by_email(friends[0])
        user_2 = User.find_by_email(friends[1])
        if activity.eql?("add_friend")
          activity = Activity.find_by_requestor_id_and_target_id(user_1.id, user_2.id)
          if activity.blank?
            Activity.create(:requestor_id => user_1.id, :target_id => user_2.id, is_friend: true)
            response["status"] = true
          else
            if activity.is_friend
              response["message"] = "#{friends.join(' and ')} are already a friend"
            else
              if activity.is_block
                response["message"] = "Can't add friend, #{friends.last} already block"
              else
                activity.update_attributes(:is_friend => true)
                response["status"] = true
              end
            end
          end
        else
          activity_1 = Activity.where(:requestor_id => user_1.id, :is_friend => true).pluck(:target_id)
          activity_2 = Activity.where(:requestor_id => user_2.id, :is_friend => true).pluck(:target_id)
          user_ids = activity_1 & activity_2
          emails = user_ids.present? ? User.where("id in (?)", user_ids).pluck(:email) : []
          response["status"] = true
          response["friends"] = emails
          response["count"] = emails.count
        end
      end
    end

    return response
  end

  def self.act(requestor, target, act)
    response = {"status" => false, "message" => ""}
    if requestor.blank? || target.blank?
      response["message"] = "Requestor and target can't be blank"
    else
      user_request = User.find_by_email(requestor)
      response["message"] = "Requestor with email #{requestor} not found" if user_request.blank?
      user_target = User.find_by_email(target)
      response["message"] = "Target with email #{target} not found" if user_target.blank?
      if user_request.present? && user_target.present?
        activity = Activity.find_by_requestor_id_and_target_id(user_request.id, user_target.id)
        if activity.blank?
          if act.eql?("subscribe")
            is_subscribe = true
            is_block = false
          else
            is_subscribe = false
            is_block = true
          end
          Activity.create(:requestor_id => user_request.id, :target_id => user_target.id, is_subscribe: is_subscribe, is_block: is_block)
          response["status"] = true
        else
          if act.eql?("subscribe")
            if activity.is_subscribe
              response["message"] = "You are already subscribe #{user_target.email}"
            else
              if activity.is_block
                response["message"] = "Can't subscribe, #{user_target.email} already block"
              else
                activity.update_attributes(:is_subscribe => true)
                response["status"] = true
              end
            end
          else
            if activity.is_block
              response["message"] = "You are already block #{user_target.email}"
            else
              activity.update_attributes(:is_block => true, :is_subscribe => false)
              response["status"] = true
            end
          end
        end
      end
    end

    return response
  end

  def self.receive_updates(sender, text)
    response = {"status" => false, "message" => ""}
    if sender.blank? || text.blank?
      response["message"] = "Sender and text can't be blank"
    else
      user_sender = User.find_by_email(sender)
      if user_sender.blank?
        response["message"] = "Sender with email #{sender} not found"
      else
        user_ids = Activity.get_updates(user_sender)
        emails = []
        mentions = text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) { |x| emails.push(x) }
        recipients = User.where("email in (?) OR id in (?)", emails, user_ids).pluck(:email)
        response["status"] = true
        response["recipients"] = recipients
      end
    end

    return response
  end

  def self.get_updates(user, platform="api")
    blocked_users = Activity.where("requestor_id = ? and is_block = ?", user.id, true).pluck(:target_id)
    if platform.eql?("api")
      friends = Activity.where("target_id = ? and is_friend = ?", user.id, true).pluck(:requestor_id)
      subscribes = Activity.where("target_id = ? and is_subscribe = ?", user.id, true).pluck(:requestor_id)
    else
      friends = Activity.where("requestor_id = ? and is_friend = ?", user.id, true).pluck(:target_id)
      subscribes = Activity.where("requestor_id = ? and is_subscribe = ?", user.id, true).pluck(:target_id)
    end
    return (friends + subscribes).uniq - blocked_users
  end
end
