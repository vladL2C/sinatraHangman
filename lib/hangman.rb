require 'json'
require_relative 'player.rb'

class Hangman
	
	def initialize 
		@used_letters = []
		@turns_left = 0
		@the_word = generate_word
		@hide_word = secret_word
		@player = Player.new		
	end 

	def menu
		puts "******************"
		puts "Welcome to Hangman"
		puts "******************"
		puts "Welcome #{@player.name} Please pick a choice: "
		puts "1. New Game"
		puts "2. Load Game"
		option = @player.option_choice
		menu_choice(option)
	
	end 
	
	def menu_choice(choice)
		case choice 
		when 1
			play_game 
		else
			puts "havnt created this method yet.." 
		end 	
		
	end 

	def play_game
		loop do
			system 'clear' 
			message
			puts "chances left: #{8 - @turns_left}"
			puts "Used letters: #{@used_letters}"
			guess = enter_guess 


			if @the_word.include?(guess)
			  correct_letter?(guess)
			else 
				@turns_left += 1  
			
			end

			if win?  
				outcome = "won"
				outcome_screen(outcome)
				break


			elsif @turns_left >= 8 
				outcome = "lost"
				outcome_screen(outcome)
				break		
			end 
			
		end 	  
	end

	def win? 
		if @hide_word == @the_word 
			return true 
		end 
	end 	

	def outcome_screen(outcome)
		system 'clear'
		puts "You have #{outcome}"
		puts "The word is #{@the_word.join()}"
		3.times do 
			print "Restarting the Game..."
			sleep(6)
			@used_letters = []
			@turns_left = 0 
			@the_word = generate_word 
			@hide_word = secret_word 
			play_game
		end 

	end 	

	def message
		puts "Word: #{@hide_word.join()}"
		puts "\n"
	end

	def generate_word
		words = File.read('5desk.txt')
		the_words = []
		words.split.each do |word|
			word = word.downcase
			if word.size > 5 && word.length < 12 
				the_words.push(word)
			end 
		end 
		picked = the_words.sample.split("")
		return picked

	end 

	def secret_word
		@hide_word = Array.new(@the_word.size,"_")
	end 

	def correct_letter?(letter) 
		@the_word.each_with_index do |l,i|
			if l == letter 
			 @hide_word[i] = letter 
			end
		end 	
	end  

	def enter_guess 
		valid = false 
		while valid == false 
			guess = @player.letter_choice
			@used_letters.push(guess)
			if ("a".."z").to_a.include?(guess) && guess.size == 1
				return guess 
				valid = true 
			end 
		end 
	end  
end 

hangman = Hangman.new
hangman.menu