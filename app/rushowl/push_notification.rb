require 'net/http'
require 'uri'
require 'json'

class PushNotification < ApplicationMailer
  def send_push_notification(conversation)
    host = ENV.fetch(
        'RUSHOWL_PUSH_NOTIFICATION_HOST',
        'http://backend-rush-notification-mq.rushowl:50050/v1/notification')
    Rails.logger.info host

    @conversation = conversation
    @contact = @conversation.contact
    @identifier = @contact.identifier

    uri = URI.parse(host)
    push_notifications = [{user: {
        title: 'You have a new message on live chat',
        body: 'Our Customer Support Officer has sent you an message on live chat. Click here to read',
        to: @identifier,
        data: {
            title: 'You have a new message on live chat',
            body: 'Our Customer Support Officer has sent you an message on live chat. Click here to read',
            link: 'https://l.rushowl.sg/chat',
            action_type: 'link'
        }
    }}].to_json
    Rails.logger.info push_notifications


    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = push_notifications
    response = http.request(request)

    Rails.logger.info response
  end
end
