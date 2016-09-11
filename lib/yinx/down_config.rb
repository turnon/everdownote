module Yinx
  class DownConfig

    attr_reader :wanted_books

    def book *books
      @wanted_books = books
    end

  end
end
