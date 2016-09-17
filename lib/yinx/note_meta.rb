require 'evernote-thrift'
require 'delegate'

class NoteMeta < DelegateClass(Evernote::EDAM::NoteStore::NoteMetadata)
  def initialize meta, note_store
    __setobj__ meta
    @store = note_store
  end

  def tags
    @tags ||= __getobj__.tagGuids.map{|id| @store.tag_name id}
  end
end
