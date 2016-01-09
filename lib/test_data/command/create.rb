require 'test_data/command'

module TestData
  class Command < Thor
    desc "create --num [NUMBER] --size [SIZE]", "create the test data."
    method_options :num => :numeric, :size => :numeric
    def create
      raise ArgumentError, "argument is nil" if options[:num] == nil || options[:size] == nil
      path = "./testdata/"
      FileUtils.mkdir_p(path) unless File.directory?(path)
      options[:num].times do |n|
        File.open(path + n.to_s, "w") do |file|
          file.truncate(options[:size])
        end
      end
    end
  end
end
