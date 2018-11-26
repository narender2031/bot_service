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
          body =  compose_message(reply['text'], reply['reply_type'], reply['buttons'])
          encounter_id =  recipient_id
          response = {
            body: body,
            user_id: encounter_id
          }
          response
        end

        def delay
          { body: nil, response_helper: nil, encounter_id: @recipient_id }
        end
        
        private

        def compose_message(message, type, actions)
          message = {
            content: {
              text: message,
              type: type,
              actions: actions || []
            }, 
            meta: {},
            type: type
          }
          return message
        end
      end
    end
  end
end