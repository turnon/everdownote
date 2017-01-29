require 'evernote-thrift'
require 'yinx/hash'
require 'yinx/array'

class Yinx::NoteMeta

  [:updated, :created, :title, :notebookGuid, :guid, :contentLength, :tagGuids].each do |method|
    define_method method do
      iv_name = "@#{method}"
      unless instance_variable_defined? iv_name
        value = instance_variable_get("@meta").send method
        instance_variable_set iv_name, value
      end
      instance_variable_get iv_name
    end
  end

  def initialize meta, note_store
    @meta = meta
    @store = note_store
  end

  def self.raw
    new nil, nil
  end

  def tags
    @tags ||= (tagGuids ? tagGuids.map{|id| @store.tag_name id} : [])
  end

  def book
    @book ||= @store.book_name notebookGuid
  end

  def stack
    @stack = (instance_variable_defined? :@stack) ? @stack : @store.stack_name(notebookGuid)
  end

  def created_at
    Time.at created / 1000
  end

  def updated_at
    Time.at updated / 1000
  end

  def to_h
    @h = attr_methods.each_with_object({}) do |method, hash|
        hash[method] = send method
      end
  end

  def marshal_dump
    to_h
  end

  def marshal_load hash
    hash.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end

  private

  def attr_methods
    self.class.instance_methods(false) - [:to_h, :marshal_dump, :marshal_load]
  end

end
