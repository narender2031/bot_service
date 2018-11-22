# coding: utf-8
# frozen_string_literal: true

require 'stealth/services/sarah/message_handler'
require 'stealth/services/sarah/reply_handler'
require 'stealth/services/sarah/setup'


module Stealth
  module Services
    module Sarah
      class Client < Stealth::Services::BaseClient
        attr_reader :body

        def initialize(reply:)
          puts "Hellllllooooooooo"
          @reply = reply 
          @body = reply[:message][:body]
          @encounter_id = reply[:encounter_id]
          @response_helper = reply[:message][:response_helper]
          # @button = ''
          # if reply[:buttons].present?
          #   @button = reply[:buttons]
          #   puts "-------------------------"
          #   puts @button
          # end
        end

        def transmit
          
          data = {
            message: body,
            user_id: @encounter_id,
            message_type: @response_helper
          }
          # Don't transmit anything for delays
          return true if body.blank? || body.nil?
          require 'uri'
          require 'net/http'
          url = URI("https://chatbot-rails-staging.herokuapp.com/api/v1/graph/results")
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Post.new(url)
          request["content-type"] = 'application/json'
          request.body =  data.to_json

          response = http.request(request)
          puts response.read_body

          [200, "comelete"]
          # Need to write the transmit api to send the response of to our rails app.   
          Stealth::Logger.l(topic: 'sarah', message: "Transmitting. Reply: #{body}.")
        end

        private

        def format_response_helper(reply)
          {
            type: reply['type'] || '',
            promptHint: reply['prompt_hint'] || '',
            options: format_options(reply['type'], reply['options']),
          }
        end
        
        def format_options(reply_type, options)
          case reply_type
          when 'TEXT'
          when 'EMAIL'
          when 'NUMBER'
          when 'DATE'
          when 'DATE_BIRTHDAY'
            options
          when 'SELECT'
          when 'BOOLEAN'
            format_options_array(options)
          # when 'NONE'
          # when 'TYPING'
          else
            nil
          end
        end

        def format_options_array(options)
          array = []
          if options
            options.each do |o|
              array << {
                label: o['label'] || '',
                description: o['description'] || '',
                value: o['value'].to_s || ''
              }
            end
          end
          array
        end
      end
    end
  end
end
