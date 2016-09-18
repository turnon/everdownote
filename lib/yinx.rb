module Yinx
  require 'yinx/user_store'
  require 'yinx/down_config'
  require 'yinx/note_meta'

  class << self

    attr_reader :config

    def new real = true, &block
      @real = real
      @config = DownConfig.new note_store
      config.instance_eval &block
      download
    end

    private

    def download
      config.note_filters.map do |filter|
	note_store.findNotes(filter)
      end.flatten.map do |note|
	NoteMeta.new note, note_store
      end
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
