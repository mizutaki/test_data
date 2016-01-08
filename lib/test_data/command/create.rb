require 'test_data/command'

module TestData
  class Command < Thor
  	desc "create [NUMBER] [SIZE]", "create test data of NUMBER SIZE"
  	def create(number, size)
      number.to_i.times do |e|
        File.open(e.to_s + ".txt", "w") do |file|
          loop do
            file.print 0
            break if file.size == size.to_i
          end
        end
      end
  	end
  end
end
