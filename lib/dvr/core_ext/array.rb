class Array

  # Not exactly useful on its own;
  # this is just for use within Hash#deep_keys
  def deep_keys
    return if empty?
    if first.is_a?(Hash) || first.is_a?(Array)
      first.deep_keys
    else
      nil
    end
  end

end
