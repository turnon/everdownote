module Everdownote
  require 'everdownote/user_store'

  class << self
    def new
      books = note_store.listNotebooks
      books.map do |book|
	metas = note_store.findNotes({notebookGuid: book.guid}).notes
	metas.map do |meta|
	  "#{meta.updated} #{note_address book, meta}\n"
	end.join
      end.join
    end

    private

    def note_store
      @note_store ||= UserStore.new.note_store
    end

    def note_address book, meta
      book.stack ? "#{book.stack}/#{book.name}/#{meta.title}" : "#{book.name}/#{meta.title}"
    end
  end
end
