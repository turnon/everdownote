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
          wanted_names.empty? ? false : wanted_names.any? do |wanted|
          wanted === name or wanted.to_s == name
        end
      end

      define_method condition do |*conditions|
        instance_variable_set "@wanted_#{condition}s", conditions
      end
    end

    def note_filters
      merged_filters_in_array = individual_filters.reduce do |merged, indv|
	merged.empty? ? indv : (indv.empty? ? merged : merged.product(indv))
      end
      merged_filters_in_hash =
	if merged_filters_in_array.fetch(0){[]}.kind_of? Array
          merged_filters_in_array.map do |sub_arr|
            sub_arr.flatten.reduce do |merged, indv|
              merged.merge indv
            end
          end
	else
          merged_filters_in_array
	end
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
      from_book = note_store.listNotebooks{ |book| want_book? book.name }
      from_stack = note_store.listNotebooks{ |book| want_stack? book.stack }
      (from_book.map(&:guid) | from_stack.map(&:guid)).map{|guid| {notebookGuid: guid}}
    end

    def tag_id_filter
      return [] if wanted_tags.empty?
      note_store.listTags do |tag|
	want_tag? tag.name
      end.map do |tag|
	{tagGuids: [tag.guid]}
      end
    end

    def words_filter
      wanted_words.map do |word|
	word = word.join ' ' if word.kind_of? Array
	{words: word.to_s}
      end
    end

  end
end
