require 'minitest/autorun'
require 'yinx'

class TestYinx < MiniTest::Unit::TestCase

  def test_filter_by_book_name
    notes = Yinx.new do
      book :book_1
    end
    assert_equal 2, notes.size
    assert_equal 1, notes.count{|n| n.title == 'note_1'}
  end

  def test_filter_by_book_names
    notes = Yinx.new do
      book :book_1, /^book_/
    end
    assert_equal 3, notes.size
    assert_equal 2, notes.count{|n| n.title == 'note_1'}
  end

  def test_filter_by_stacks
    notes = Yinx.new do
      stack :stack_1, :stack_2
    end
    assert_equal 4, notes.size
    assert_equal 2, notes.count{|n| n.title == 'note_1'}
  end

  def test_filter_by_tags
    notes = Yinx.new do
      tag :tag_1, 'tag_2'
    end
    assert_equal %w{note_2 note_3}, notes.map(&:title).sort
  end

  def test_filter_by_word_in_one_note
    notes = Yinx.new do
      word 'in_note3'
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_word_in_more_than_one_note
    notes = Yinx.new do
      word 'qwertyuiop'
    end
    assert_equal 2, notes.size
    assert_equal %w{note_2 note_3}, notes.map(&:title).sort
  end

  def test_filter_by_words
    notes = Yinx.new do
      word 'qwertyuiop in_note3'
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_words_in_array
    notes = Yinx.new do
      word %w{qwertyuiop in_note3}
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_symbol_word
    notes = Yinx.new do
      word :in_note3
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_word_and_stack
    notes = Yinx.new do
      stack 'stack_1'
      word 'qwertyuiop'
    end
    assert_equal %w{note_2}, notes.map(&:title)
  end

  def test_filter_by_word_and_book
    notes = Yinx.new do
      word 'qwertyuiop'
      book 'book_2'
    end
    assert_empty notes
  end

  def test_filter_by_word_and_tag
    notes = Yinx.new do
      word 'qwertyuiop'
      tag 'tag_1'
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_word_and_tags
    notes = Yinx.new do
      word 'qwertyuiop'
      tag 'tag_2', :tag_1
    end
    assert_equal %w{note_2 note_3}, notes.map(&:title).sort
  end

  def test_all_filters_applied
    notes = Yinx.new do
      word 'qwertyuiop'
      tag /tag_/
      book /book_/
      stack 'stack_1', :stack_2
    end
    assert_equal %w{note_2}, notes.map(&:title)
  end

end
