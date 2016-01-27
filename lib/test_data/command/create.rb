require 'test_data/command'
require 'nokogiri'
require 'fileutils'
require 'builder/xmlmarkup'

module TestData
  class Command < Thor
    desc "create --path [DESTINATION_PATH] --name [NAME] --num [NUMBER] --size [SIZE]", "create the test data."
    method_option :path, :type => :string, :default => "./testdata/"
    method_option :name, :type => :string, :default => "test"
    method_options :num => :numeric, :size => :numeric
    def create
      raise ArgumentError, "argument is nil" if options[:num] == nil || options[:size] == nil
      path = options[:path]
      FileUtils.mkdir_p(path) unless File.directory?(path)
      options[:num].times do |n|
        wrtite_file(path + options[:name] + n.to_s, options[:size])
      end
    end

    desc "create_tree --read [READ_FILEPATH]", "create content tree."
    method_option :read, :type => :string, :required => true
    def create_tree
      raise IOError, "file is not found --read: #{options[:read]}" unless File.exist?(options[:read])
      file = File.open(options[:read])
      xml = Nokogiri::XML(file)
      xml.xpath("//testdata").children.each do |child|
        unless child.node_name == "text"
          create_content_recursion(child,"./" + child.attributes["name"].value)
        end
      end
    end

    desc "read_tree --read [READ_FILEPATH] --write [WRITE_FILEPATH]", "read content tree to create a xml file."
    method_option :read, :type => :string, :required => true
    method_option :write, :type => :string, :required => true
    def read_tree
      puts options[:read]
      raise IOError, "file is not found --read: #{options[:read]}" unless File.exist?(options[:read])
      ret = ""
      sub_contents = Dir.entries(options[:read])
      xml = Builder::XmlMarkup.new(:target => ret, :indent => 2)
      xml.instruct!
      rootfolder_name = options[:read].split("\/").last
      puts rootfolder_name
      xml.testdata {
        xml.rootfolder(:name => rootfolder_name) {
          read_tree_recursion(xml, sub_contents, options[:read])
        }
      }
      File.open(options[:write], "w") do |file|
        file.puts ret
      end
    end

    private
    def create_content_recursion(child, parent_path)
      child.children.each do |c|
        unless c.node_name == "text"
          if c.node_name == "folder"
            puts "folder"
            current_name = c.attributes["name"].value#TODO name is nil throw exception
            current_path = parent_path + "/" + current_name
            puts "parent_path:" + parent_path
            FileUtils.mkdir_p(current_path) unless FileTest.exist?(current_path)
            create_content_recursion(c,current_path)
          elsif c.node_name == "file"
            puts "file"
            unless c.attributes["size"].nil? || c.attributes["count"].nil?
              count = c.attributes["count"].value
              count.to_i.times do |n|
                wrtite_file(parent_path + "/" + c.attributes["name"] + n.to_s, c.attributes["size"].value.to_i)
              end
            else
              unless c.attributes["size"].nil?
                wrtite_file(parent_path + "/" + c.attributes["name"], c.attributes["size"].value.to_i)
              end
            end
          else
            raise StandardError, "undefined xml tag name #{c.node_name}"
          end
        end
      end
    end

    def wrtite_file(file_path, size)
      File.open(file_path, "w") do |file|
        file.truncate(size)
      end
    end

    def read_tree_recursion(xml, sub_contents, parent_path)
      sub_contents.each do |content_name|
        unless "." == content_name  || ".." == content_name || content_name =~ /^\.d*/
          current_path = parent_path + "/" + content_name
          puts "current_path:" + current_path
          is_dir = FileTest.directory?(current_path)
          puts is_dir
          if is_dir
            puts "folder"
            sub = Dir.entries(current_path)
            xml.folder(:name => content_name) {
              read_tree_recursion(xml,sub, current_path)
            }
          else
            size = File.size(current_path)
            puts size
            xml.file(:name => content_name, :size => size)
          end
        end
      end
    end
  end
end