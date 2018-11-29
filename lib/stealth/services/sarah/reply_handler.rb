module Stealth
  module Services
    module Sarah
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply

        def initialize(recipient_id:, reply:)
          @recipient_id = recipient_id
          @reply = reply.reply
        end

        def text
          resposne = compose_message(reply: reply)
          puts resposne
          resposne
        end

        def email
          resposne = compose_message(reply: reply)
          puts resposne
          resposne
        end

        def delay
          { body: nil, response_helper: nil, encounter_id: @recipient_id }
        end
        
        private


        def compose_message(reply:)
          check_if_arguments_are_valid(suggestions: reply['suggestions'], buttons: reply['buttons'])
          template = message_template
          template[:message][:type] = reply['reply_type']
          template[:message][:text] = reply['text']

          if reply['suggestions'].present?
            # didn't work on the suggestions
          end

          if reply['buttons'].present?
            buttons = generate_buttons(buttons: reply['buttons'])
            actions = button_action_template(buttons: buttons)
            template[:message][:actions] = actions
          end
          template
        end

        def check_if_arguments_are_valid(suggestions:, buttons:)
          if suggestions.present? && buttons.present?
            raise(ArgumentError, "A reply cannot have buttons and suggestions!")
          end
        end

        def message_template
          {
            user_id: recipient_id,
            message: { 
              type: '',
              text: '',
              actions: {}
            }
          }
        end

        def generate_buttons(buttons:)
          reply_buttons =  buttons.collect do |button|
            case button['type']
            when 'payload'
              button = {
                type: "postback",
                payload: button['payload'],
                text: button['text'],
                other: button['other_value']
              }

            when 'urls'
              button = {
                type: "web_url",
                url: button['url'],
                text: button['text'],
                other: button['other_value']
              }

            when 'call'
              button = {
                type: "phone_number",
                payload: button["phone_number"],
                text: button["text"],
                other: button['other_value']
              }

            when 'email'
              button = {
                type: "email",
                payload: button["email"],
                text: button['text'],
                other: button['other_value']
              }

            else
              button = {
                type: button['type'],
                payload: button['payload'],
                text: button['text'],
                url: button['url'],
                other: button['other_value']
                
              }
            end
            button
          end
          reply_buttons
        end

        def button_action_template(buttons:)
          {
            acction_type:'buttons',
            buttons: buttons
          }
        end
      end
    end
  end
end