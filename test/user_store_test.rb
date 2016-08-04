require 'minitest/autorun'
require 'everdownote/user_store'

class TestUserStore < MiniTest::Unit::TestCase

  attr_reader :user_store

  def setup
    @user_store = UserStore.new
  end

  def test_choose_testing_host
    assert_equal UserStore::SANDBOX, user_store.host
  end

  def test_choose_production_host
    user_store = UserStore.new true
    assert_equal UserStore::REAL, user_store.host
  end

  def test_api_update
    assert user_store.checkVersion
  end

  def test_default_token
    token = File.read(UserStore::TOKEN).chomp
    assert_equal token, user_store.default_token
  end

  def test_get_note_store
    assert_kind_of NoteStore, user_store.note_store
  end
end
