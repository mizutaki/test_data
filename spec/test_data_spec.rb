require 'spec_helper'
require 'fileutils'

describe TestData do
  describe 'version' do
    it 'has a version number' do
      expect(TestData::VERSION).not_to be nil
    end
  end

  describe 'create' do
    after :each do
      FileUtils.rm_r(Dir.glob('./testdata'), {:force=>true})
    end

    it "should one test data size 1byte" do
      TestData::Command.new.invoke(:create, [],{:num => 1, :size => 1})
      expect(1).to eq File.size("./testdata/0")
      expect(1).to eq Dir.glob("./testdata/*").length
    end

    it "should thousand test data size 1000byte" do
      TestData::Command.new.invoke(:create, [],{:num => 1000, :size => 1000})
      expect(1000).to eq File.size("./testdata/0")
      expect(1000).to eq Dir.glob("./testdata/*").length
    end
  end
end
