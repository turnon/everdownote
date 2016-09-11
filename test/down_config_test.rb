require 'minitest/autorun'
require 'yinx/down_config'

class TestDownConfig < MiniTest::Unit::TestCase

  def test_book
    dc = new_dc
    dc.book '123'
    assert_equal ['123'], dc.wanted_books
  end

  def test_stack
    dc = new_dc
    dc.stack '123', '456'
    assert_equal ['123','456'], dc.wanted_stacks
  end

  def test_no_config
    dc = new_dc
    assert_equal [], dc.wanted_stacks
    assert_equal [], dc.wanted_books
  end

  private

  def new_dc
    Yinx::DownConfig.new
  end
end
