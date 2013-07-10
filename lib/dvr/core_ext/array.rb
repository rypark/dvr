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

  # To be called on a Hash#deep_keys result.
  def ensure_no_subtractions(other)
    bools = map do |elem|
      case elem
      when String
        other.include?(elem)
      when Hash
        match = other.find { |e|e.is_a?(Hash) && e.keys[0] == elem.keys[0] }
        match ? elem.values[0].ensure_no_subtractions(match.values[0]) : false
      end
    end
    bools.all?
  end

end
