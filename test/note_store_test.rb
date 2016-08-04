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
end
