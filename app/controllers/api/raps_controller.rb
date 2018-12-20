class Api::RapsController < ApplicationController
  require 'line/bot'

  before_action :parse_event_params

  def battle
    @events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event['message']['type']
        when Line::Bot::Event::MessageType::Text
          rg = RhymeGenerator.new(event.message['text'])
          rhyme = rg.get_rhyme
          if Rails.env.production?
            msg = { type: 'text', text: rhyme }
            result = line_client.reply_message(@reply_token, msg)
            print_line_post_result(result)
          else
            puts rhyme
          end
        end
      end
    end
    render json: {}, status: :ok
  end

  def battle_with_pee
    @events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event['message']['type']
        when Line::Bot::Event::MessageType::Text
          session[:loaded] = true
          rg = RhymeGenerator2.new(event.message['text'], session.id)
          rhyme = rg.get_rhyme
          if Rails.env.production?
            msg = { type: 'text', text: rhyme }
            result = line_client.reply_message(@reply_token, msg)
            print_line_post_result(result)
          else
            puts rhyme
          end
        end
      end
    end
    render json: {}, status: :ok
  end

  def battle_with_marco
    @events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event['message']['type']
        when Line::Bot::Event::MessageType::Text
          session[:loaded] = true
          rg = RhymeGenerator3.new(event.message['text'])
          rhyme = rg.get_rhyme
          if Rails.env.production?
            msg = { type: 'text', text: rhyme }
            result = line_client.reply_message(@reply_token, msg)
            print_line_post_result(result)
          else
            puts rhyme
          end
        end
      end
    end
    render json: {}, status: :ok
  end

  private

  def line_client(pee: nil)
    @line_client ||= Line::Bot::Client.new do |config|
      if params[:action] == 'battle_with_pee'
        config.channel_secret = ENV['LINE_CHANNEL_SECRET_PEE']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN_PEE']
      else
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      end
    end
  end

  def get_events_from_request
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    if Rails.env.production? && !line_client.validate_signature(body, signature)
      raise 'Bad Request'
    end

    line_client.parse_events_from(body)
  end

  def parse_event_params
    @events = get_events_from_request
    @reply_token  = @events[0]['replyToken']
    logger.debug "evnets: " + @events.inspect
  end

  def print_line_post_result(result)
    case result
    when Net::HTTPSuccess, Net::HTTPRedirection
      logger.info "LINE POST: OK"
    else
      logger.error "\n\nLINE POST: NG ///////////////////////"
      logger.error result.body
      logger.error "/////////////////////////////////////\n\n"
    end
  end
end
