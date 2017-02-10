require 'evernote-thrift'

class Yinx::NoteMeta

  OfficialApi = [:updated, :created, :title, :notebookGuid, :guid, :contentLength, :tagGuids]

  FullApi = OfficialApi + [:tags, :book, :stack]

  OfficialApi.each do |method|
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
    @h = FullApi.each_with_object({}) do |method, hash|
        hash[method] = send method
      end
  end

  def self.from_h hash
    raw = new nil, nil
    raw.marshal_load hash
    raw
  end

  def marshal_dump
    to_h
  end

  def marshal_load hash
    hash.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end

  NoTagGuid, NoTag = 'NoTagGuid', 'NoTag'

  def unwind_tags
    if tags.empty?
      [_unwind_tags(NoTagGuid, NoTag)]
    else
      tagGuids.zip(tags).map do |tag_id, tag_name|
        _unwind_tags tag_id, tag_name
      end
    end
  end

  protected

  attr_writer :tagGuids, :tags

  private

  def _unwind_tags tag_id, tag_name
    uw = self.dup
    uw.tagGuids = tag_id
    uw.tags = tag_name
    uw
  end

end
