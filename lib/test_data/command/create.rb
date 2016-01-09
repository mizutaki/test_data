require 'test_data/command'

module TestData
  class Command < Thor
    desc "create [NUMBER] [SIZE]", "create the test data."
  	def create(number, size)
      number.to_i.times do |e|
        File.open("./testdata/" + e.to_s, "w") do |file|
          file.truncate(size.to_i)
        end
      end
  	end
  end
end
