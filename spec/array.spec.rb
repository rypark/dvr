require_relative 'spec_helper'

describe Array do

  describe "#deep_keys" do

    it "returns nil for a simple array" do
      ['Nacho', 'Ignacio'].deep_keys.must_be_nil
    end

    it "returns nil for nested simple arrays" do
      [%w[a b c], %w[d e f]].deep_keys.must_be_nil
    end

    it "returns key for an array of simple hashes" do
      [{'name' => 'Nacho'},
       {'name' => 'Ignacio'}
      ].deep_keys.must_equal ['name']
    end

  end

  describe "#ensure_no_subtractions" do

    let(:deep_keys) {
      [{'animals'=>['whiskers', 'name']}, 'vegetables']
    }
    let(:new_deep_keys) {
      [{'animals'=>['whiskers', 'name']}, 'vegetables']
    }

    it "returns true when no changes made" do
      deep_keys.ensure_no_subtractions(new_deep_keys).must_equal true
    end

    it "returns true when new keys added" do
      new_deep_keys[0]['animals'] << 'furry'
      deep_keys.ensure_no_subtractions(new_deep_keys).must_equal true
    end

    it "returns false when keys subtracted" do
      new_deep_keys[0]['animals'].delete_at(1)
      deep_keys.ensure_no_subtractions(new_deep_keys).must_equal false
    end

    it "handles empty hashes" do
      deep_keys = [ { } ]
      deep_keys.ensure_no_subtractions(deep_keys).must_equal true
    end

  end

end
