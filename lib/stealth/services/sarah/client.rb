# coding: utf-8
# frozen_string_literal: true
require 'uri'
require 'net/http'
require 'stealth/services/sarah/message_handler'
require 'stealth/services/sarah/reply_handler'
require 'stealth/services/sarah/setup'


module Stealth
  module Services
    module Sarah
      class Client < Stealth::Services::BaseClient
        attr_reader :body, :user_id
        API_URL= Stealth.config.sarah.response_url
        USE_SSL= Stealth.config.sarah.use_ssl
        def initialize(reply:)
          @reply = reply
        end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank? || reply.nil?
          url = URI("#{API_URL}")
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = USE_SSL
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          request = Net::HTTP::Post.new(url)
          request["content-type"] = 'application/json'
          request.body = reply.to_json

          response = http.request(request)

          puts response.read_body
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
