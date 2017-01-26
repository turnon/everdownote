require 'evernote-thrift'
require 'forwardable'

class NoteMeta

  extend Forwardable
  def_delegators :@meta, :updated, :created, :title, :notebookGuid, :guid, :contentLength, :tagGuids

  def initialize meta, note_store
    @meta = meta
    @store = note_store
  end

  def tags
    @tags ||= (tagGuids ? tagGuids.map{|id| @store.tag_name id} : [])
  end

  def book
    @book ||= @store.book_name notebookGuid
  end

  def stack
    @stack ||= @store.stack_name notebookGuid
  end

  def to_h
    @h = (self.class.instance_methods(false) - [:to_h]).each_with_object({}) do |method, hash|
      hash[method] = send method
    end
  end

end
