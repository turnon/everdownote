module Yinx
  class DownConfig

    attr_reader :note_store

    class NullNoteStore < BasicObject
      def method_missing *p
	:Kernel.send :raise, 'note store not set'
      end
    end

    def initialize note_st = NullNoteStore.new
      @note_store = note_st
    end

    %w{book stack tag word}.each do |condition|
      define_method "wanted_#{condition}s" do
	instance_variable_get("@wanted_#{condition}s") || []
      end

      define_method "want_#{condition}?" do |name|
	wanted_names = self.send "wanted_#{condition}s"
	wanted_names.empty? ? true : wanted_names.any? do |wanted|
	  wanted === name or wanted.to_s == name
	end
      end

      define_method condition do |*conditions|
	instance_variable_set "@wanted_#{condition}s", conditions
      end
    end

    def note_filters
      merged_filters = individual_filters.reduce do |rs, arr|
	rs = rs.empty? ? arr : (arr.empty? ? rs : rs.product(arr))
	rs
      end
      merged_filters.flatten! if merged_filters.fetch(0){[]}.kind_of? Array
      merged_filters
    end

    private

    def individual_filters
      self.private_methods.select do |m|
	m =~ /filter$/
      end.map do |filter_convertor|
	self.send filter_convertor
      end
    end

    def book_id_filter
      return [] if wanted_books.empty? and wanted_stacks.empty?
      note_store.listNotebooks do |book|
	want_book? book.name and want_stack? book.stack
      end.map do |book|
	{notebookGuid: book.guid}
      end
    end

    def tag_id_filter
      return [] if wanted_tags.empty?
      ids = note_store.listTags do |tag|
	want_tag? tag.name
      end.map do |tag|
	tag.guid
      end
      [{tagGuids: ids}]
    end

    def words_filter
      wanted_words.map do |word|
	word = word.join ' ' if word.kind_of? Array
	{words: word.to_s}
      end
    end

  end
end
