require 'test_data/command'

module TestData
  class Command < Thor
  	desc "create [NUMBER]", "create test data of NUMBER"
  	def create(number)
      number.to_i.times do |e|
        File.open(e.to_s + ".txt", "w") do |file|
        	file.puts e
        end
      end
  	end
  end
end
