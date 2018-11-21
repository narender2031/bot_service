# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Sarah
      class MessageHandler < Stealth::Services::BaseMessageHandler

        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          puts "Hllo Message"
          puts "params #{params}"
          @params = params
          @headers = headers
        end

        def coordinate
          puts "hello cordinate"
          Stealth::Services::HandleMessageJob.perform_async('sarah', params, {})
          # Relay our acceptance
        end

        def process
          puts "hello process"
          puts "process_params: #{params}"
          @service_message = ServiceMessage.new(service: 'sarah')
          @service_message.sender_id = params['encounter_id']
          @service_message.message = params['value']
          
          puts "service_message: #{@service_message}"
          @service_message
        end

      end
    end
  end
end
