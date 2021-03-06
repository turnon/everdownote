require 'evernote-thrift'
require 'yinx/helper'
require 'yinx/note_store'

module Yinx
  class UserStore

    attr_reader :userStore

    SANDBOX = "sandbox.evernote.com"
    #REAL = "www.evernote.com"
    REAL = "app.yinxiang.com"

    TOKEN = "#{ENV['HOME']}/.yinx"

    def initialize real_env = true
      @real = real_env
      userStoreUrl = "https://#{host}/edam/user"
      userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
      userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
      @userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)
    end

    def host
      @real ? REAL : SANDBOX
    end

    def checkVersion
      userStore.checkVersion("Evernote EDAMTest (Ruby)",
                             Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                             Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
    end

    def note_store authToken = default_token
      NoteStore.new userStore, authToken
    end

    def default_token
      return ENV['YINX'] if ENV['YINX']
      File.exist?(TOKEN) ? File.read(TOKEN).chomp : nil
    end

  end
end
