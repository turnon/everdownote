module Yinx
  require 'yinx/user_store'
  require 'yinx/down_config'

  class << self
    def new real = true, &block
      DownConfig.new.instance_eval &block
      Array.new 2
    end

    private

    def note_store real
      @note_store ||= UserStore.new(real).note_store
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
