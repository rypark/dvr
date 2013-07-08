class Hash

  # Like Hash#keys, but handles deeply nested hashes within the primary hash.
  # 
  def deep_keys
    result = { }
    each do |k, v|
      result[k] = if v.is_a?(Hash) || v.is_a?(Array)
        v.deep_keys
      else
        nil
      end
    end
    if result.count > 1
      result.map { |k, v| v ? {k => v} : k }
    else
      result.values != [nil] ? result : [result.keys[0]]
    end
  end

end
