class Hash
  def to_yinx
    raw = Yinx::NoteMeta.raw
    raise TypeError, "can not convert #{self} to Yinx::NoteMeta" unless raw.send(:attr_methods).all?{|m| self.has_key?(m) or self.has_key?(m.to_s)}
    raw.marshal_load self
    raw
  end

end
