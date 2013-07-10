require_relative 'spec_helper'
require 'json'

describe DVR::Dvd do

  let(:tmp_dir) {
    File.join(
      DVR::SPEC_ROOT,
      '/../tmp/dvr_library_dir/new_dir'
    )
  }
  let(:dvd)  { DVR::Dvd.new('test_file') }
  let(:json) { {'hi' => 'there'}.to_json }

  before {
    DVR.configure do |c|
      c.dvd_library_dir = tmp_dir
    end
  }

  after(:each)  { FileUtils.rm_rf tmp_dir }

  describe "#save_to_file" do

    it "saves to file if it doesn't yet exist" do
      dvd.save_to_file(json).must_equal true
      File.exists?(tmp_dir + '/test_file.json').must_equal true
    end

    it "doesn't save if file already exists" do
      File.open("#{tmp_dir}/test_file.json", 'w') { |f| f.write(json) }
      dvd.save_to_file(json).must_equal false
    end

  end

  describe "#body" do

    it "returns nil if file is not persisted" do
      dvd.body.must_be_nil
    end

    it "matches the original json" do
      dvd.save_to_file(json)
      dvd.body.must_equal json
    end

  end

  describe "#compare!" do

    # TODO this could use some cleaning
    it "compares structure of response json" do
      dvd_body = {
        'animals' => %w[lion tiger bear]
      }.to_json
      response_body = {
        'animals' => %w[cat dog chinchilla]
      }.to_json

      dvd.stub(:body, dvd_body) do
        dvd.compare!(response_body).must_equal true
      end
    end

    it "correctly compares array" do
      dvd_body = [
        {'name' => 'lion'},
        {'name' => 'tiger'},
        {'name' => 'bear'},
      ].to_json
      response_body = [
        {'name' => 'lemur'}
      ].to_json

      dvd.stub(:body, dvd_body) do
        dvd.compare!(response_body).must_equal true
      end
    end

    it "resaves to dvd when new structure has been added" do
      dvd_body = {
        'animals' => %w[lion tiger bear]
      }.to_json
      response_body = {
        'animals' => %w[cat dog chinchilla],
        'fruits'  => %w[apple peache pear]
      }.to_json

      dvd.stub(:body, dvd_body) do
        dvd.compare!(response_body).must_equal true
        assert_send [dvd, :save_to_file, response_body, force: true]
      end
    end

    it "returns false when structure has been subtracted" do
      dvd_body = {
        'animals' => [
          {'id' => 1, 'name' => 'lion'}
        ]
      }.to_json
      response_body = {
        'animals' => [
          {'name' => 'lion'}
        ]
      }.to_json

      dvd.stub(:body, dvd_body) do
        dvd.compare!(response_body).must_equal false
      end
    end

  end

  describe "error handling" do

    it "raises NonJsonResponse if response body isn't valid json" do
      -> { dvd.save_to_file("<!DOCTYPE html><html></html>") }
      .must_raise(DVR::NonJsonResponse)
    end

  end

end
