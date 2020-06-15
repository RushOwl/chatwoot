require 'net/http'
require 'uri'
require 'json'

class PushNotification < ApplicationMailer
  def send_push_notification(conversation)
    host = ENV.fetch('RUSHOWL_PUSH_NOTIFICATION_HOST', nil)
    return unless host
    @conversation = conversation
    @contact = @conversation.contact

    uri = URI.parse(host)

    header = {'Content-Type': 'text/json'}
    push_notifications = [{user: {
        title: 'You have a new message on live chat',
        body: 'Our Customer Support Officer has sent you an message on live chat. Click here to read',
        to: @contact&.identifier,
        data: {
            title: 'You have a new message on live chat',
            body: 'Our Customer Support Officer has sent you an message on live chat. Click here to read',
            link: 'https://l.rushowl.sg/chat',
            action_type: 'link'
        }
    }}]

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = push_notifications.to_json
    http.request(request)
  end
end
