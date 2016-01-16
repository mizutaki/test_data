require 'test_data/command'
require 'nokogiri'
require 'fileutils'

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
        File.open(path + options[:name] + n.to_s, "w") do |file|
          file.truncate(options[:size])
        end
      end
    end

    desc "create_tree --read [READ_FILEPATH]", "create content tree."
    method_option :path, :type => :string, :default => "./sandbox/test.xml"
    def create_tree
      file = File.open(options[:path])
      xml = Nokogiri::XML(file)
      xml.xpath("//testdata").children.each do |child|
        unless child.node_name == "text"
          create_content_recursion(child,"./" + child.attributes["name"].value)
        end
      end
    end

    private
    def create_content_recursion(child, parent_path)
      child.children.each do |c|
        unless c.node_name == "text"
          if c.node_name == "folder"
            puts "folder"
            current_name = c.attributes["name"].value
            current_path = parent_path + "/" + current_name
            puts "parent_path:" + parent_path
            FileUtils.mkdir_p(current_path) unless FileTest.exist?(current_path)
            create_content_recursion(c,current_path)
          elsif c.node_name == "file"
            puts "file"
            File.open(parent_path + "/" + c.attributes["name"], "w") do |file|
              puts file
            end
          end
        end
      end
    end
  end
end