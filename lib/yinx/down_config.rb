module Yinx
  class DownConfig

    %w{book stack tag}.each do |condition|
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

  end
end
