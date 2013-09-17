# Hato::Plugin::Mail [![BuildStatus](https://secure.travis-ci.org/kentaro/hato-plugin-mail.png)](http://travis-ci.org/kentaro/hato-plugin-mail)

This plugin provides a method to send messages via mail.

## Configuration

```ruby
Hato::Config.define do
  api_key 'test'
  host    '0.0.0.0'
  port    9699

  # ...

  tag 'test' do
    plugin 'Mail' do
      smtp address:   'smtp.example.com',
           port:      587,
           domain:    'example',
           user_name: 'hato',
           password:  'password',
           enable_ssl: true

      subject_template = <<EOS
[<%= args[:tag] %>] Notification
EOS
      body_template = <<EOS
You've got a message:

<%= args[:message] %>
EOS

      message from: 'hato@example.com',
              to:   [
                'foo@example.com',
                'bar@example.com',
              ],
              subject_template: subject_template,
              body_template:    body_template
    end
  end

  # ...
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'hato-plugin-mail'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hato-plugin-mail

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

