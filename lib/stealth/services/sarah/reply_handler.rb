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
          response = {
            encounter_id: @recipient_id,
            message:{
              body:  reply['text'],
              response_helper: reply['reply_type'] || { type: 'NONE' },
            },
            buttons:  reply['buttons']
          }
          response
        end

        def delay
          { body: nil, response_helper: nil, encounter_id: @recipient_id }
        end

      end
    end
  end
end