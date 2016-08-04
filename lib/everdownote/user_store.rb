require 'evernote-thrift'
require 'everdownote/note_store'

class UserStore

  attr_reader :userStore

  SANDBOX = "sandbox.evernote.com"
  REAL = "www.evernote.com"

  TOKEN = "#{ENV['HOME']}/.everdownote"

  def initialize real_env = false
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
    File.exists?(TOKEN) ? File.read(TOKEN).chomp : nil
  end

end
