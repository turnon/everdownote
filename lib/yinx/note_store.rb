require 'evernote-thrift'

module Yinx
  class NoteStore

    attr_reader :auth_token

    NOTE_FILTERS = [:order, :ascending, :words,
                    :notebookGuid, :tagGuids, :timeZone,
                    :inactive, :emphasized]#, :includeAllReadableNotebooks]

    NOTE_META_RESULT_SPECS = [:includeTitle, :includeContentLength,
  			    :includeCreated, :includeUpdated,
  			    :includeDeleted, :includeUpdateSequenceNum,
  			    :includeNotebookGuid, :includeTagGuids,
  			    :includeAttributes, :includeLargestResourceMime,
  			    :includeLargestResourceSize]

    def note_store
      @noteStore
    end

    def initialize userStore, authToken
      noteStoreUrl = userStore.getNoteStoreUrl(authToken)
      noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
      noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
      @auth_token = authToken
      @noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)
    end

    def listNotebooks authToken = auth_token, &blk
      notebooks = note_store.listNotebooks(authToken)
      block_given? ? notebooks.select(&blk) : notebooks
    end

    def listTags &blk
      note_store.listTags(auth_token).select &blk
    end

    def findNotes opt = {}
      note_store.findNotesMetadata auth_token, filter(opt), 0, 100, spec(opt)
    end

    private

    def filter opt = {}
      filter = Evernote::EDAM::NoteStore::NoteFilter.new
      merge filter, opt, NOTE_FILTERS
      filter.order ||= Evernote::EDAM::Type::NoteSortOrder::UPDATED
      filter
    end

    def spec opt = {}
      spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
      merge spec, opt, NOTE_META_RESULT_SPECS
      spec.includeTitle ||= true
      spec.includeUpdated ||= true
      spec
    end

    def merge struct, hash, keys
      keys.each do |k|
        struct.send (k.to_s + '=').to_sym, hash[k]
      end
      struct
    end
  end
end
