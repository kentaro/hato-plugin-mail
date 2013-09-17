require 'hato/plugin'
require 'hato/plugin/mail/version'

require 'erb'
require 'mail'

module Hato
  module Plugin
    class Mail < Base
      def notify(args)
        if smtp_opts = config.smtp
          ::Mail.defaults do
            delivery_method :smtp, (
              smtp_opts.to_hash.keys.inject({}) { |opts, key|
                opts[key.to_sym] = smtp_opts.send(key.to_sym)
                opts
              }
            )
          end
        end

        to_addresses = config.message['to']
        to_addresses = [to_addresses] if to_addresses.is_a?(String)

        to_addresses.each do |to_address|
          send_mail(to_address, args)
        end
      end

      protected

      def send_mail(to_address, args)
        mail = {
          from:    config.message['from'],
          subject: render(config.message['subject_template'], args),
          body:    render(config.message['body_template'], args),
        }

        ::Mail.deliver do
          from    mail[:from]
          to      to_address
          subject mail[:subject]
          body    mail[:body]
        end
      end

      def render(template, args)
        erb = ERB.new(template)
        erb.result(binding).chomp
      end
    end
  end
end

