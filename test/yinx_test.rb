require 'test_helper'
require 'yinx'

class TestYinx < MiniTest::Unit::TestCase

  def test_that_it_has_a_version_number
    refute_nil ::Yinx::VERSION
  end

  def test_fetch_all_books
    books = Yinx.fetch_all_books.map &:stack_book
    assert_includes books, 'stack_1/book_1'
    assert_includes books, 'stack_2/3rd_book'
  end

  def test_fetch_all_tags
    tags = Yinx.fetch_all_tags.map &:name
    assert_includes tags, 'tag_1'
    assert_includes tags, 'tag_2'
  end

  def test_filter_by_book_name
    notes = Yinx.fetch do
      book :book_1
    end
    assert_equal 2, notes.size
    assert_equal 1, notes.count{|n| n.title == 'note_1'}
  end

  def test_filter_by_book_names
    notes = Yinx.fetch do
      book :book_1, /^book_/
    end
    assert_equal 3, notes.size
    assert_equal 2, notes.count{|n| n.title == 'note_1'}
  end

  def test_filter_by_stacks
    notes = Yinx.fetch do
      stack :stack_1, :stack_2
    end
    assert_equal 4, notes.size
    assert_equal 2, notes.count{|n| n.title == 'note_1'}
  end

  def test_filter_by_tags
    notes = Yinx.fetch do
      tag :tag_1, 'tag_2'
    end
    assert_equal %w{note_2 note_3}, notes.map(&:title).sort
  end

  def test_filter_by_word_in_one_note
    notes = Yinx.fetch do
      word 'in_note3'
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_word_in_more_than_one_note
    notes = Yinx.fetch do
      word 'qwertyuiop'
    end
    assert_equal 2, notes.size
    assert_equal %w{note_2 note_3}, notes.map(&:title).sort
  end

  def test_filter_by_words
    notes = Yinx.fetch do
      word 'qwertyuiop in_note3'
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_words_in_array
    notes = Yinx.fetch do
      word %w{qwertyuiop in_note3}
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_symbol_word
    notes = Yinx.fetch do
      word :in_note3
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_word_and_stack
    notes = Yinx.fetch do
      stack 'stack_1'
      word 'qwertyuiop'
    end
    assert_equal %w{note_2}, notes.map(&:title)
  end

  def test_filter_by_word_and_book
    notes = Yinx.fetch do
      word 'qwertyuiop'
      book 'book_2'
    end
    assert_empty notes
  end

  def test_filter_by_word_and_tag
    notes = Yinx.fetch do
      word 'qwertyuiop'
      tag 'tag_1'
    end
    assert_equal %w{note_3}, notes.map(&:title)
  end

  def test_filter_by_word_and_tags
    notes = Yinx.fetch do
      word 'qwertyuiop'
      tag 'tag_2', :tag_1
    end
    assert_equal %w{note_2 note_3}, notes.map(&:title).sort
  end

  def test_all_filters_applied
    notes = Yinx.fetch do
      word 'qwertyuiop'
      tag /tag_/
      book /book_/
      stack 'stack_1', :stack_2
    end
    assert_equal %w{note_2 note_3}, notes.map(&:title).sort
  end

  def test_return_metadata
    assert_meta_correct note_with_tag_1
  end

  def test_dump
    note = note_with_tag_1
    note = Marshal.load(Marshal.dump(note))
    assert_meta_correct note
  end

  def test_to_yinx
    note = note_with_tag_1
    note = Yinx::NoteMeta.from_h note.to_h
    assert_meta_correct note
  end

  private

  def note_with_tag_1
    notes = Yinx.fetch do
      tag :tag_1
    end
    notes[0]
  end

  def assert_meta_correct note
    assert_respond_to note, :tags
    assert_equal %w{tag_1}, note.tags
    assert_respond_to note, :book
    assert_equal '3rd_book', note.book
    assert_respond_to note, :stack
    assert_equal 'stack_2', note.stack
    assert_respond_to note, :created
    assert_respond_to note, :updated
    assert_respond_to note, :contentLength
    hash = note.to_h
    assert_equal %w{tag_1}, hash[:tags]
    assert_equal '3rd_book', hash[:book]
    assert_equal 'stack_2', hash[:stack]
    assert hash[:contentLength]
    assert hash[:created]
    assert hash[:updated]
  end

end
