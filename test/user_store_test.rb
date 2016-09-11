require 'minitest/autorun'
require 'yinx/user_store'

class TestUserStore < MiniTest::Unit::TestCase

  UserStore = Yinx::UserStore

  def test_choose_testing_host
    assert_equal UserStore::SANDBOX, UserStore.new(false).host
  end

  def test_choose_production_host
    user_store = UserStore.new
    assert_equal UserStore::REAL, user_store.host
  end

  def test_api_update
    assert UserStore.new.checkVersion
  end

  def test_default_token
    token = File.read(UserStore::TOKEN).chomp
    assert_equal token, UserStore.new.default_token
  end

end
