require 'test_helper'
require 'yinx/user_store'

class TestNoteStore < MiniTest::Unit::TestCase

  attr_reader :note_store

  def setup
    @note_store = Yinx::UserStore.new.note_store
  end

  def test_get_note_store
    assert_kind_of Yinx::NoteStore, note_store
  end

  def test_get_notebook_by_name
    prebuilt = note_store.listNotebooks do |b|
      b.name == 'book_1'
    end
    assert_equal 1, prebuilt.size

    metas = note_store.findNotes({notebookGuid: prebuilt[0].guid})
    titles = metas.map(&:title)
    assert_includes titles, 'note_1'
  end

  def test_get_notebook_by_stack
    books = note_store.listNotebooks do |b|
      b.stack == 'stack_1'
    end
    assert_equal 2, books.size

    metas = note_store.findNotes({notebookGuid: books[0].guid})
    titles = metas.map(&:title)
    assert_includes titles, 'note_1'
  end
end
