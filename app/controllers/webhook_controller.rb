require 'line/bot'

class WebhookController < ApplicationController
  include ApplicationHelper

  protect_from_forgery except: :callback

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: Line::return_ramdom_message
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Location
          rest = Gurunavi::return_rest(event.message['latitude'], event.message['longitude'])
          messages = [
            {
            type: "flex",
            altText: "this is a flex message",
            contents: {
              type: "bubble",
              body: {
                type: "box",
                layout: "vertical",
                contents: [
                  {
                    type: "text",
                    text: return_unknown_if_blank(rest["name"]),
                    weight: "bold",
                    size: "xl"
                  },
                  {
                    type: "box",
                    layout: "vertical",
                    margin: "lg",
                    spacing: "sm",
                    contents: [
                      {
                        type: "box",
                        layout: "baseline",
                        spacing: "sm",
                        contents: [
                          {
                            type: "text",
                            text: "住所",
                            color: "#aaaaaa",
                            size: "sm",
                            flex: 1
                          },
                          {
                            type: "text",
                            text: return_unknown_if_blank(rest["address"]),
                            wrap: true,
                            color: "#666666",
                            size: "sm",
                            flex: 5
                          }
                        ]
                      },
                      {
                        type: "box",
                        layout: "baseline",
                        spacing: "sm",
                        contents: [
                          {
                            type: "text",
                            text: "営業時間",
                            color: "#aaaaaa",
                            size: "sm",
                            flex: 1
                          },
                          {
                            type: "text",
                            text: return_unknown_if_blank(rest["opentime"]),
                            wrap: true,
                            color: "#666666",
                            size: "sm",
                            flex: 5
                          }
                        ]
                      },
                      {
                        type: "box",
                        layout: "baseline",
                        spacing: "sm",
                        contents: [
                          {
                            type: "text",
                            text: "電話番号",
                            color: "#aaaaaa",
                            size: "sm",
                            flex: 1
                          },
                          {
                            type: "text",
                            text: return_unknown_if_blank(rest["tel"]),
                            wrap: true,
                            color: "#666666",
                            size: "sm",
                            flex: 5
                          }
                        ]
                      }
                    ]
                  }
                ]
              },
              footer: {
                type: "box",
                layout: "vertical",
                spacing: "sm",
                contents: [
                  {
                    type: "button",
                    style: "link",
                    height: "sm",
                    action: {
                      type: "uri",
                      label: "ぐるなび",
                      uri: return_unknown_if_blank(rest["url_mobile"])
                    }
                  },
                  {
                    type: "spacer",
                    size: "sm"
                  }
                ],
                flex: 0
              }
            }
          },
          {
            type: 'text',
            text: "このお店に行こうよ！"
          }
          ]
            client.reply_message(event['replyToken'], messages)
        end
      end
    }

    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
