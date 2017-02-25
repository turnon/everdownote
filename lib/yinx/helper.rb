class Evernote::EDAM::Type::Notebook
  def stack_book
    stack ? "#{stack}/#{name}" : "#{name}"
  end
end
