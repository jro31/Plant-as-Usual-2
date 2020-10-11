require 'rails_helper'

RSpec.describe UserMailer do
  email_parts = ['text_part', 'html_part']
  let(:user) { create(:user, email: 'rachelamber@arcadiabay.beforethestorm', username: 'rachelamber') }

  describe '#welcome_email' do
    subject { UserMailer.welcome_email(user) }
    it 'sends an email' do
      expect(subject.deliver_now).to be_kind_of(Mail::Message)
    end

    describe 'from' do
      it { expect(subject.from).to eq(['noreply@plantasusual.com']) }
    end

    describe 'to' do
      it { expect(subject.to).to eq(['rachelamber@arcadiabay.beforethestorm']) }
    end

    describe 'subject' do
      it { expect(subject.subject).to eq('Welcome to My Awesome Site') }
    end

    describe 'body' do
      it 'sends two body parts' do
        expect(subject.body.parts.count).to eq(2)
      end

      it 'sends a text part' do
        expect(subject.body.parts[0].content_type).to eq('text/plain; charset=UTF-8')
      end

      it 'sends an html part' do
        expect(subject.body.parts[1].content_type).to eq('text/html; charset=UTF-8')
      end

      describe 'key phrases' do
        key_phrases = [
          'Welcome to example.com, rachelamber',
          'You have successfully signed up to example.com, your username is: rachelamber.',
          'To login to the site, just follow this link: http://example.com/login.',
          'Thanks for joining and have a great day!'
        ]
        email_parts.each do |part|
          describe part.humanize do
            key_phrases.each do |phrase|
              it "includes '#{phrase}'" do
                expect(subject.send(part).encoded.gsub(/\r\n/, ' ')).to include(phrase)
              end
            end
          end
        end
      end
    end
  end
end
