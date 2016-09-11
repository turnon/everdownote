module Yinx
  require 'yinx/user_store'
  require 'yinx/down_config'

  class << self

    attr_reader :config

    def new real = true, &block
      @real = real
      @config = DownConfig.new
      config.instance_eval &block
      download
    end

    private

    def note_filters
      merge book_id_filter, tag_id_filter
    end

    def book_id_filter
      return [] if config.wanted_books.empty? and config.wanted_stacks.empty?
      note_store.listNotebooks do |book|
	config.want_book? book.name and config.want_stack? book.stack
      end.map &:guid
    end

    def tag_id_filter
      return [] if config.wanted_tags.empty?
      note_store.listTags do |tag|
	config.want_tag? tag.name
      end.map &:guid
    end

    def download
      find_with note_filters
    end

    def find_with filters
      filters.map do |filter|
	note_store.findNotes(filter).notes
      end.flatten
    end

    def merge book_ids, tag_ids
      return book_ids.map do |book_id|
	tag_ids.empty? ? {notebookGuid: book_id} : {notebookGuid: book.guid, tagGuids: tag_ids}
      end unless book_ids.empty?
      [{tagGuids: tag_ids}]
    end

    def note_store
      @note_store ||= UserStore.new(@real).note_store
    end

    def formated book, meta
      address = book.stack ? "#{book.stack}/#{book.name}/#{meta.title}" : "#{book.name}/#{meta.title}"
      time = Time.at(meta.updated / 1000).strftime('%F %T')
      "#{meta.updated} #{time} #{address}"
    end

    def concat_metas real
      books = note_store(real).listNotebooks &block
      books.map do |book|
	metas = note_store.findNotes({notebookGuid: book.guid}).notes
	metas.map do |meta|
	  "#{formated book, meta}\n"
	end.join
      end.join
    end
  end
end
