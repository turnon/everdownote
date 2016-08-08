require 'minitest/autorun'
require 'everdownote/user_store'

class TestNoteStore < MiniTest::Unit::TestCase

  attr_reader :note_store

  def setup
    @note_store = UserStore.new.note_store
  end

  def test_get_note_store
    assert_kind_of NoteStore, note_store
  end

  def test_get_notebook_by_name
    prebuilt = note_store.listNotebooks do |b|
      b.name == '示例笔记本'
    end
    assert_equal 1, prebuilt.size

    metas = note_store.findNotes({notebookGuid: prebuilt[0].guid}).notes
    titles = metas.map(&:title)
    assert_includes titles, '保存照片'
  end

end
