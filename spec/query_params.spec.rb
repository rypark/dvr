require_relative 'spec_helper'

describe DVR::Util::QueryParams do

  it 'turns nested hash into http params' do
    hash = {'a' => {'b' => 'c', 'd' => 'e'}}
    DVR::Util::QueryParams.encode(hash).must_equal 'a[b]=c&a[d]=e'
  end

end
