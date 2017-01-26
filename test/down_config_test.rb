require 'test_helper'
require 'yinx/down_config'

class TestDownConfig < MiniTest::Unit::TestCase

  def test_book
    dc = new_dc
    dc.book '123'
    assert_equal ['123'], dc.wanted_books
    assert dc.want_book? '123'
  end

  def test_stack
    dc = new_dc
    dc.stack '123', '456'
    assert_equal ['123','456'], dc.wanted_stacks
    assert dc.want_stack? '456'
  end

  def test_tag
    dc = new_dc
    dc.tag '123', '456'
    assert_equal ['123','456'], dc.wanted_tags
    refute dc.want_tag? 'abc'
  end

  def test_no_config
    dc = new_dc
    assert_equal [], dc.wanted_stacks
    assert_equal [], dc.wanted_books
    assert_equal [], dc.wanted_tags
    refute dc.want_stack? 'jfgdfs'
    refute dc.want_book? 'kfjb'
    refute dc.want_tag? 'uryrs'
  end

  def test_note_filters_without_setting_note_store
    dc = new_dc
    dc.book 'fhjhj'
    assert_raises(RuntimeError) { dc.note_filters  }
  end

  private

  def new_dc
    Yinx::DownConfig.new
  end
end
