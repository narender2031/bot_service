module Stealth
  module Services
    module Sarah
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply

        def initialize(recipient_id:, reply:)
          puts "Hllo Reply"
          puts recipient_id
          puts reply.inspect
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          response = {
            encounter_id: @recipient_id,
            message:{
              body:  @reply.reply['text'],
              response_helper: @reply.reply['reply_type'] || { type: 'NONE' },
            },
            buttons:  @reply.reply['buttons']

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