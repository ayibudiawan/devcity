require "spec_helper"
require "rails_helper"

RSpec.describe Api::V1::DevCitiesController, :type => :controller do
  before(:each) do
    request.accept = 'application/json'
  end

  describe 'POST add friends and common friends' do
    it 'should display a successful message for add friends' do
      body = {
        "friends" => [
          "lisa@devcity.co.id",
          "kate@devcity.co.id",
        ]
      }
      post "add_friend", params: body
      expect(response).to have_http_status(200)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response).to be_successful
    end

    it 'should display a successful message for common friends' do
      body = {
        "friends" => [
          "andy@devcity.co.id",
          "john@devcity.co.id",
        ]
      }
      post "common_friend", params: body
      expect(response).to have_http_status(200)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response).to be_successful
      expect(response.body).to eq({success: true,  friends: ["lisa@devcity.co.id"], count: 1}.to_json)
    end

    it 'should throw error message parameter must be array and consist of 2 email' do
      post "add_friend", params: { "friends" => ["ayi@gmail.com"] }
      @message = "Parameter must be array and consist of 2 email"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end

    it 'should throw error message user with email 1, email 2 not found' do
      body = {
        "friends" => [
          "ayibudiawan@gmail.com",
          "ayi@gmail.com",
        ]
      }
      post "add_friend", params: body
      @message = "User with email #{body['friends'].join(',')} not found"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end

    it 'should throw error message user 1 and user 2 are already a friend' do
      body = {
        "friends" => [
          "andy@devcity.co.id",
          "john@devcity.co.id",
        ]
      }
      post "add_friend", params: body
      @message = "#{body['friends'].join('and')} are already a friend"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end

    it 'should throw error message cant add friend, user already block' do
      body = {
        "friends" => [
          "andy@devcity.co.id",
          "kate@devcity.co.id",
        ]
      }
      post "add_friend", params: body
      @message = "Can't add friend, #{body['friends'].last} already block"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end
  end

  describe 'GET friend list' do
    it 'should display a success message' do
      @params = { email: "andy@devcity.co.id" }
      get "friend_list", params: @params
      expect(response).to have_http_status(200)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response).to be_success
      expect(response.body).to eq({success: true,  friends: ["john@devcity.co.id", "lisa@devcity.co.id"], count: 2}.to_json)
    end
    it 'should throw error message user with email email_name not found' do
      @params = { email: 'ayi@gmail.com' }
      @message = "User with email #{@params[:email]} not found"
      get "friend_list", params: @params
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end
  end

  describe 'POST subscribe and block user' do
    it 'should display a successful message for subscribe user' do
      body = {
        "requestor" => "andy@devcity.co.id",
        "target" => "lisa@devcity.co.id"
      }
      post "subscribe", params: body
      expect(response).to have_http_status(200)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response).to be_successful
    end

    it 'should display a successful message for block user' do
      body = {
        "requestor" => "andy@devcity.co.id",
        "target" => "john@devcity.co.id"
      }
      post "block", params: body
      expect(response).to have_http_status(200)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response).to be_successful
    end

    it 'should throw error message requestor with email email_name not found' do
      post "subscribe", params: { "requestor" => "ayi@gmail.com", "target" => "lisa@devcity.co.id" }
      @message = "Requestor with email ayi@gmail.com not found"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end

    it 'should throw error message target with email email_name not found' do
      post "subscribe", params: { "requestor" => "john@devcity.co.id", "target" => "ayi@gmail.com" }
      @message = "Target with email ayi@gmail.com not found"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end

    it 'should throw error message you are already subscribe email_name' do
      post "subscribe", params: { "requestor" => "andy@devcity.co.id", "target" => "john@devcity.co.id" }
      @message = "You are already subscribe john@devcity.co.id"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end

    it 'should throw error message cant subscribe already block email_name' do
      post "subscribe", params: { "requestor" => "andy@devcity.co.id", "target" => "kate@devcity.co.id" }
      @message = "Can't subscribe, kate@devcity.co.id already block"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end

    it 'should throw error message you already block email_name' do
      post "block", params: { "requestor" => "andy@devcity.co.id", "target" => "kate@devcity.co.id" }
      @message = "You are already block kate@devcity.co.id"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end
  end

  describe 'POST receive updates' do
    it 'should display a successful message for receive updates' do
      body = {
        "sender" => "john@devcity.co.id",
        "text" => "Hello world!, andy@devcity.co.id, kate@devcity.co.id"
      }
      post "receive_updates", params: body
      expect(response).to have_http_status(200)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response).to be_successful
      expect(response.body).to eq({success: true,  recipients: ["andy@devcity.co.id", "lisa@devcity.co.id", "kate@devcity.co.id"]}.to_json)
    end

    it 'should throw error message sender with email email_name not found' do
      post "receive_updates", params: { "sender" => "ayi@gmail.com", "text" => "Hello world" }
      @message = "Sender with email ayi@gmail.com not found"
      expect(response).to have_http_status(400)
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.body).to eq({success: false,  message: @message}.to_json)
    end
  end
end