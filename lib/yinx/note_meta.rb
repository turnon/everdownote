require 'evernote-thrift'
require 'delegate'

class NoteMeta < DelegateClass(Evernote::EDAM::NoteStore::NoteMetadata)
  def initialize meta, note_store
    __setobj__ meta
    @store = note_store
  end

  def tags
    @tags ||= begin
		tag_ids = __getobj__.tagGuids
		tag_ids ? tag_ids.map{|id| @store.tag_name id} : []
	      end
  end

  def book
    @book ||= @store.book_name __getobj__.notebookGuid
  end

  def stack
    @stack ||= @store.stack_name __getobj__.notebookGuid
  end

  Keys = %w{title book stack tags}.map &:to_sym

  def to_h
    Keys.reduce({}) do |hash, key|
      hash[key] = send(key)
      hash
    end
  end
end
