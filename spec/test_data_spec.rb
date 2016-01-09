require 'spec_helper'
require 'fileutils'

describe TestData do
  describe 'version' do
    it 'has a version number' do
      expect(TestData::VERSION).not_to be nil
    end
  end

  describe 'create' do
    before :each do
      @path = "./testdata/*"
    end

    after :each do
      FileUtils.rm_r(Dir.glob('./testdata'), {:force=>true})
    end

    it "should no arguments" do
      expect{TestData::Command.new.invoke(:create)}.to raise_error("argument is nil")
    end

    it "should zero test data size 0byte" do
      TestData::Command.new.invoke(:create, [],{:num => 0, :size => 0})
      expect(Dir.glob(@path).length).to eq 0
    end

    it "should one test data size 1byte" do
      TestData::Command.new.invoke(:create, [],{:num => 1, :size => 1})
      expect(File.size("./testdata/0")).to eq 1
      expect(Dir.glob(@path).length).to eq 1
    end

    it "should thousand test data size 1000byte" do
      TestData::Command.new.invoke(:create, [],{:num => 1000, :size => 1000})
      expect(File.size("./testdata/0")).to eq 1000
      expect(Dir.glob(@path).length).to eq 1000
    end
  end
end
