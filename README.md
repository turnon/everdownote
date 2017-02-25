# Yinx

Fetch note metdata with evernote api

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yinx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yinx

## Usage

Put your api key in `$HOME/.yinx`, or `export YINX=yourkey`, then:

```ruby
notes = Yinx.fetch_all
```

To filter out:

```ruby
notes = Yinx.fetch do
  word  'active record'
  tag   'rails'
  book  'ruby'
  stack 'programming language'
end
```

Or you may just get books or tags info:

```ruby
books = Yinx.fetch_all_books
tags = Yinx.fetch_all_tags
```
