module Yinx
  class DownConfig

    #attr_reader :wanted_books, :wanted_stacks

    #def book *books
    #  @wanted_books = books
    #end

    #def stack *stacks
    #  @wanted_stacks = stacks
    #end

    %w{book stack}.each do |condition|
      define_method "wanted_#{condition}s" do
	instance_variable_get("@wanted_#{condition}s") || []
      end

      define_method condition do |*conditions|
	instance_variable_set "@wanted_#{condition}s", conditions
      end
    end

  end
end
