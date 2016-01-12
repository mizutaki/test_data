require 'rexml/document'

class ContentGeneration

  attr_accessor :parentfolder_path, :current_foder_path

  def initialize(parentfolder)
    self.parentfolder_path = parentfolder
  end

  def create_content_recrsive(elements, parentfolder)
    
  end
end

doc = REXML::Document.new(File.new("test.xml"))
REXML::XPath.match(doc,"testdata")[0].each_element do |root|
  root_folder_name = root.attributes["name"]
  root.each_element('folder') do |e|
    puts "e:" + e.attributes["name"]
    e.each_element('folder') do |r|
      puts "r:" + r.attributes["name"]
    end
  end
end