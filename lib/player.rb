class Player
attr_accessor :name

	def initialize
		@name = set_name
	end

	def set_name 
		puts "Please enter your name: "
		name = gets.chomp

	end 

	def option_choice
		 loop do 
			puts "Please make your choice: "
			input = gets.chomp.to_i
			if input < 1 || input > 2 
				"try again"
			else 
				return input
				break
			end
		end 
	end	 	



	def letter_choice
		puts "Pick your letter or write save to save your game: "
		letter = gets.chomp
	end 

end 
