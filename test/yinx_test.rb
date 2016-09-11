require 'minitest/autorun'
require 'yinx'

class TestYinx < MiniTest::Unit::TestCase

  def test_show_all_but_breif
    skip
    info = Yinx.new
    assert_match %r(stack_1/book_1/note_1), info
    assert_match(/2016/, info)
  end

  def test_take_block
    block_run = false
    Yinx.new do
      block_run = true
    end
    assert block_run
  end

  def test_take_block_to_filter_notes
    notes = Yinx.new do
      book :book_1
    end
    assert_equal 2, notes.size
    assert_equal 1, notes.count{|n| n.title == 'note_1'}
  end

end
