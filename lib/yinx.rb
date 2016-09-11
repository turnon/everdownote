module Yinx
  require 'yinx/user_store'
  require 'yinx/down_config'

  class << self
    def new real = true, &block
      @real = real
      config = DownConfig.new
      config.instance_eval &block
      download config
    end

    private

    def download config
      books = note_store.listNotebooks do |book|
	match_book = config.wanted_books.empty? ? true : config.wanted_books.any? do |wanted_book|
	  wanted_book === book.name or wanted_book.to_s === book.name
	end
	match_stack = config.wanted_stacks.empty? ? true : config.wanted_stacks.any? do |wanted_stack|
	  wanted_stack === book.stack or wanted_stack.to_s === book.stack
	end
	match_book and match_stack
      end
      tags = note_store.listTags do |tag|
	config.wanted_tags.any? do |wanted_tag|
	  wanted_tag === tag.name or wanted_tag.to_s === tag.name
	end
      end
      find_with books, tags
    end

    def find_with books, tags
      tag_ids = tags.map{|t| t.guid}
      books.map do |book|
	note_store.findNotes({notebookGuid: book.guid, tagGuids: tag_ids}).notes
      end.flatten
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
