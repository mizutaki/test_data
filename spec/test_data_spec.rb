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
      TestData::Command.new.invoke(:create, [],{:name => "test", :num => 1, :size => 1})
      expect(File.size("./testdata/test0")).to eq 1
      expect(Dir.glob(@path).length).to eq 1
    end

    it "should thousand test data size 1000byte" do
      TestData::Command.new.invoke(:create, [],{:name => "test", :num => 1000, :size => 1000})
      expect(File.size("./testdata/test0")).to eq 1000
      expect(Dir.glob(@path).length).to eq 1000
    end

    it "should path defalut value ./testdata/" do
      TestData::Command.new.invoke(:create, [],{:name => "test", :num => 1, :size => 1})
      expect(File.exist?('./testdata/test0')).to be true
    end

    it "should name defalut value test" do
      TestData::Command.new.invoke(:create, [],{:path => "./folder/", :num => 1, :size => 1})
      expect(File.exist?('./folder/test0')).to be true
    end
  end

  describe 'create_tree' do
    after :each do
      FileUtils.rm_r(Dir.glob('./top'), {:force=>true})
    end

    it "should path defalut value tree content" do
      TestData::Command.new.invoke(:create_tree, [],{:path => "./spec/testdata/test1.xml"})
      expect(File.exist?('./top/1/11/111/test1.txt')).to be true
      expect(File.exist?('./top/2/22/test2.txt')).to be true
      expect(File.exist?('./top/3')).to be true
      expect(File.exist?('./top/test.txt')).to be true
    end

    it "should read file not found exception" do
      path = "./spec/1234/lmx.xml"
      expect{TestData::Command.new.invoke(:create_tree, [],{:path => path})}.to raise_error("file is not found -- path: #{path}")
    end

    it "should nudefined xml tag name exception" do
      path = "./spec/testdata/test2.xml"
      expect{TestData::Command.new.invoke(:create_tree, [],{:path => path})}.to raise_error("undefined xml tag name filee")
      expect(File.exist?('./top/1/11/111/test1.txt')).to be true
    end

  end
end
