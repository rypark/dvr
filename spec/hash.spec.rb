require_relative 'spec_helper'

describe Hash do

  describe "#deep_keys" do

    it "works with very basic hash" do
      h = {'animals' => ['cat', 'mouse']}
      h.deep_keys.must_equal ['animals']
    end

    it "works with pretty basic hash" do
      h = {'animals'    => ['cat', 'mouse'],
           'vegetables' => ['potato', 'squash']}
      h.deep_keys.must_equal ['animals', 'vegetables']
    end

    it "works with nested hashes" do
      h = {
        'animals' => [
          {'name' => 'cat', 'whiskers' => true},
          {'name' => 'dog', 'whiskers' => false}
        ],
        'vegetables' => [
          'potato',
          'squash'
        ]
      }
      expected_keys = [{"animals" => ["name", "whiskers"]}, "vegetables"]
      h.deep_keys.must_equal expected_keys
    end

  end

end
