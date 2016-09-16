require 'minitest/autorun'
require 'yinx'

class TestYinx < MiniTest::Unit::TestCase

  def test_show_all_but_breif
    skip
    info = Yinx.new
    assert_match %r(stack_1/book_1/note_1), info
    assert_match(/2016/, info)
  end

  def test_take_block_to_filter_notes_by_book_name
    notes = Yinx.new do
      book :book_1
    end
    assert_equal 2, notes.size
    assert_equal 1, notes.count{|n| n.title == 'note_1'}
  end

  def test_take_block_to_filter_notes_by_book_names
    notes = Yinx.new do
      book :book_1, /^book_/
    end
    assert_equal 3, notes.size
    assert_equal 2, notes.count{|n| n.title == 'note_1'}
  end

  def test_take_block_to_filter_notes_by_stacks
    notes = Yinx.new do
      stack :stack_1, :stack_2
    end
    assert_equal 4, notes.size
    assert_equal 2, notes.count{|n| n.title == 'note_1'}
  end

  def test_take_block_to_filter_notes_by_tags
    notes = Yinx.new do
      tag :tag_1
    end
    assert_equal 1, notes.size
    assert_equal %w{note_3}, notes.map{|n| n.title}
  end

  def test_take_block_to_filter_notes_by_word_in_one_note
    notes = Yinx.new do
      word 'in_note3'
    end
    assert_equal 1, notes.size
    assert_equal %w{note_3}, notes.map{|n| n.title}
  end

  def test_take_block_to_filter_notes_by_word_in_more_than_one_note
    notes = Yinx.new do
      word 'qwertyuiop'
    end
    assert_equal 2, notes.size
    assert_equal %w{note_2 note_3}, notes.map{|n| n.title}
  end

  def test_take_block_to_filter_notes_by_words
    notes = Yinx.new do
      word 'qwertyuiop in_note3'
    end
    assert_equal 1, notes.size
    assert_equal %w{note_3}, notes.map{|n| n.title}
  end

  def test_take_block_to_filter_notes_by_words_in_array
    notes = Yinx.new do
      word %w{qwertyuiop in_note3}
    end
    assert_equal 1, notes.size
    assert_equal %w{note_3}, notes.map{|n| n.title}
  end

  def test_take_block_to_filter_notes_by_symbol_word
    notes = Yinx.new do
      word :in_note3
    end
    assert_equal 1, notes.size
    assert_equal %w{note_3}, notes.map{|n| n.title}
  end

end
