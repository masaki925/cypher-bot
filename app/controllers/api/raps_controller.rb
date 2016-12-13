class Api::RapsController < ApplicationController
  require 'line/bot'

  before_action :parse_event_params

  def battle
    render json: {}, status: :ok
  end

  private

  def line_client
    @line_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def get_events_from_request
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    if Rails.env.production? && !line_client.validate_signature(body, signature)
      raise text: 'Bad Request'
    end

    line_client.parse_events_from(body)
  end

  def parse_event_params
    @events = get_events_from_request
    @reply_token  = @events[0]['replyToken']
    logger.debug "evnets: " + @events.inspect
  end
end
