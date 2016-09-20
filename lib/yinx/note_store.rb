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
      @notebooks ||= note_store.listNotebooks(authToken)
      block_given? ? @notebooks.select(&blk) : @notebooks
    end

    def listTags &blk
      @tags ||= note_store.listTags(auth_token)
      block_given? ? @tags.select(&blk) : @tags
    end

    def stack_name id
      @stack_hash ||= Hash[listNotebooks.map{|book| [book.guid, book.stack]}]
      @stack_hash[id]
    end

    def book_name id
      @book_hash ||= Hash[listNotebooks.map{|book| [book.guid, book.name]}]
      @book_hash[id]
    end

    def tag_name id
      @tag_hash ||= Hash[listTags.map{|tag| [tag.guid, tag.name]}]
      @tag_hash[id]
    end

    def findNotes opt = {}
      fl, start, ending, sp = filter(opt), 0, 250, spec(opt)
      md_list = note_store.findNotesMetadata auth_token, fl, start, ending, sp
      result = md_list.notes
      while md_list.totalNotes > start + ending
	start += ending
        md_list = note_store.findNotesMetadata auth_token, fl, start, ending, sp
	result.concat md_list.notes
      end
      result
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
