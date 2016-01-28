require 'spec_helper'
require 'fileutils'

describe TestData do
  describe 'version' do
    it 'has a version number' do
      expect(TestData::VERSION).not_to be nil
    end
  end

  describe 'create command test' do
    before :each do
      @path = "./testdata/*"
    end

    after :each do
      FileUtils.rm_r(Dir.glob('./testdata'), {:force=>true})
    end

    it "if the argument :size is nil, it will be in error" do
      expect{TestData::Command.new.invoke(:create, [], {:num => 1})}.to raise_error("argument is nil")
    end

    it "if the argument :num is nil, it will be in error" do
      expect{TestData::Command.new.invoke(:create, [], {:size => 1})}.to raise_error("argument is nil")
    end

    it "if you run with the default setting" do
      TestData::Command.new.invoke(:create, [], {:num => 1, :size => 1})
      expect(File.size("./testdata/test0")).to eq 1
      expect(Dir.glob(@path).length).to eq 1
    end

    it "test data size and the number is 0" do
      TestData::Command.new.invoke(:create, [],{:num => 0, :size => 0})
      expect(Dir.glob(@path).length).to eq 0
    end

    it "testing if the file name is in japanese" do
      file_name = "データ作成てすと"
      create_path = ".testdata/1/2/"
      TestData::Command.new.invoke(:create, [],{:path => create_path, :name => file_name, :num => 1, :size => 1})
      expect(File.size("#{create_path}#{file_name}0")).to eq 1
      expect(Dir.glob(create_path).length).to eq 1
    end
=begin
    it "file creation test of large size(1GB)" do
      TestData::Command.new.invoke(:create, [],{:name => "test", :num => 1, :size => 1073741824})
      expect(File.size("./testdata/test0")).to eq 1073741824
      expect(Dir.glob(@path).length).to eq 1
    end

    it "a lot of file creation test" do
      create_path = "./testdata/manymany/"
      TestData::Command.new.invoke(:create, [],{:path => create_path, :name => "test", :num => 100000, :size => 10})
      expect(Dir.glob("#{create_path}*").length).to eq 100000
    end

    it "a lot of file creation test in its own way also size" do
      create_path = "./testdata/manymany/"
      TestData::Command.new.invoke(:create, [],{:path => create_path, :name => "test", :num => 10000, :size => 10240})
      expect(Dir.glob("#{create_path}*").length).to eq 10000
      directory_size = 0
      Dir.glob("#{create_path}*") do |file|
       next if File.directory?(file)
       directory_size += File.stat(file).size
      end
      expect(directory_size).to eq 102400000
    end
=end
  end

  describe 'create_tree commnad test' do
    after :each do
      FileUtils.rm_r(Dir.glob('./top'), {:force=>true})
    end

    it "test if the read destination file not does not exist" do
      read_path = "./file/not/found/test.xml"
      expect{TestData::Command.new.invoke(:create_tree, [],{:read => read_path})}.to raise_error("file is not found --read: #{read_path}")
    end

    it "read destination path argument is not specified" do
      expect{TestData::Command.new.invoke(:create_tree, [],{})}.to raise_error("No value provided for required options '--read'")
    end

    it "create simple tree structure" do
      TestData::Command.new.invoke(:create_tree, [],{:read => "./spec/testdata/create_test1.xml"})
      10.times do |t|
        expect(File.exist?('./top/1/11/111/test1' + t.to_s)).to be true
        expect(File.size('./top/1/11/111/test1' + t.to_s)).to eq 1
      end
      5.times do |t|
        expect(File.exist?('./top/2/22/test2' + t.to_s)).to be true
        expect(File.size('./top/2/22/test2' + t.to_s)).to eq 10000
      end
      expect(File.exist?('./top/3')).to be true
      1.times do |t|
        expect(File.exist?('./top/test' + t.to_s)).to be true
        expect(File.size('./top/test' + t.to_s)).to eq 10
      end
    end

    it "xml no attribute size" do
      path = "./spec/testdata/create_test2.xml"
      TestData::Command.new.invoke(:create_tree, [],{:read => path})
      expect(File.exist?('./top/1/11/111')).to be true
      50.times do |t|
        expect(File.exist?('./top/1/11/111/test1.txt' + t.to_s)).to be false
      end
      expect(File.exist?('./top/2/22')).to be true
      20.times do |t|
        expect(File.exist?('./top/2/22/test2.txt' + t.to_s)).to be false
      end
      expect(File.exist?('./top/3')).to be true
    end

    it "xml no attribute count" do
      path = "./spec/testdata/create_test3.xml"
      TestData::Command.new.invoke(:create_tree, [],{:read => path})
      expect(File.exist?('./top/1/11/111')).to be true
      expect(File.size('./top/1/11/111/test1.txt')).to eq 20
      expect(File.exist?('./top/2/22')).to be true
      expect(File.size('./top/test.txt')).to eq 10000
      expect(File.exist?('./top/3')).to be true
    end
  end

  describe 'read_tree' do
     after :each do
      FileUtils.rm_r(Dir.glob('./ret.xml'), {:force=>true})
      FileUtils.rm_r(Dir.glob('./top'), {:force=>true})
      FileUtils.rm_r(Dir.glob('./todo'), {:force=>true})
    end

    it "write and read destination path argument is not specified" do
      expect{TestData::Command.new.invoke(:read_tree, [],{})}.to raise_error("No value provided for required options '--read', '--write'")
    end

    it "write destination path argument is not specified" do
      expect{TestData::Command.new.invoke(:read_tree, [],{:read => "aaa"})}.to raise_error("No value provided for required options '--write'")
    end

    it "read destination path argument is not specified" do
      expect{TestData::Command.new.invoke(:read_tree, [],{:write => "aaa"})}.to raise_error("No value provided for required options '--read'")
    end

    it "test if the read destination file not does not exist" do
      read_path = "./file/not/found/test.xml"
      expect{TestData::Command.new.invoke(:read_tree, [],{:read => read_path, :write => "./aaa/write.xml"})}.to raise_error("file is not found --read: #{read_path}")
    end

    it "less content file has a same" do
      path = "./spec/testdata/read_test.xml"
      write_path = "./tree.xml"
      TestData::Command.new.invoke(:create_tree, [],{:read => path})
      TestData::Command.new.invoke(:read_tree, [],{:read => "./top", :write => write_path})
      FileUtils.cmp(path,write_path)
    end

    it "there are many content file has a same" do
      path = "./spec/testdata/read_test2.xml"
      write_path = "./tree.xml"
      TestData::Command.new.invoke(:create_tree, [],{:read => path})
      TestData::Command.new.invoke(:read_tree, [],{:read => "./todo", :write => write_path})
      FileUtils.cmp(path,write_path)
    end
  end
end
