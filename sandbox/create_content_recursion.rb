require 'nokogiri'
require 'fileutils'

def create_content_recursion(child, parent_path)
  child.children.each do |c|
    unless c.node_name == "text"
      if c.node_name == "folder"
        puts "folder"
        puts c.attributes["name"]
        current_name = c.attributes["name"].value
        current_path = parent_path + "/" + current_name
        puts "parent_path:" + parent_path
        FileUtils.mkdir_p(current_path) unless FileTest.exist?(current_path)
        create_content_recursion(c,current_path)
      elsif c.node_name == "file"
        puts "file"
        puts c.attributes["name"]
        File.open(parent_path + "/" + c.attributes["name"], "w") do |file|
          puts file
        end
      end
    end
  end
end

file = File.open('test.xml')
xml = Nokogiri::XML(file)
xml.xpath("//testdata").children.each do |child|
  unless child.node_name == "text"
    create_content_recursion(child,"./" + child.attributes["name"].value)
  end
end