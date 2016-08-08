require 'minitest/autorun'
require 'everdownote'

class TestEverdownote < MiniTest::Unit::TestCase

  def test_show_all_but_breif
    info = Everdownote.new
    assert_match %r(stack_1/book_1/note_1), info
  end

end
