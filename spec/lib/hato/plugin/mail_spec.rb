require_relative '../../../spec_helper'
require 'hato/config'

describe Hato::Plugin::Mail do
  before {
    ::Mail.defaults { delivery_method :test }
    ::Mail::TestMailer.deliveries.clear
  }

  describe '#notify' do
    context 'arguments' do
      context 'mail address' do
        context 'when channel is passed as a string' do
          subject {
            described_class.new(
              Hato::Config::Plugin.new('Mail') {
                message from: 'hato@example.com',
                        to:   'foo@example.com',
                        subject_template: 'subject',
                        body_template:    'body'
              }
            )
          }
          before {
            subject.notify(tag: 'test', message: 'test')
          }

          it {
            expect(::Mail::TestMailer.deliveries.length).to be == 1
          }
        end

        context 'when channel is passed as an array' do
          subject {
            described_class.new(
              Hato::Config::Plugin.new('Mail') {
                message from: 'hato@example.com',
                        to:   %w[foo@example.com bar@example.com],
                        subject_template: 'subject',
                        body_template:    'body'
              }
            )
          }
          before {
            subject.notify(tag: 'test', message: 'test')
          }

          it {
            expect(::Mail::TestMailer.deliveries.length).to be == 2
          }
        end
      end
    end

    context 'template' do
      subject {
        described_class.new(
          Hato::Config::Plugin.new('Mail') {
            message from: 'hato@example.com',
                    to:   'foo@example.com',
                    subject_template: '[<%= args[:tag] %>] notification',
                    body_template:    'message: <%= args[:message] %>'
          }
        )
      }
      before {
        subject.notify(tag: 'test', message: 'test')
      }

      it {
        mail = ::Mail::TestMailer.deliveries.first
        expect(mail.subject).to be      == '[test] notification'
        expect(mail.body.decoded).to be == 'message: test'
      }
    end
  end
end

