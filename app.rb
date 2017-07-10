require 'sinatra'
require 'sinatra/reloader' if development?


enable :sessions


get '/' do
start_game
session[:hide_word] = secret_word		
erb :index
end



helpers do

	def start_game
		@used_letters = []
		@turns_left = 0
		@the_word = generate_word
		@hide_word = session[:hide_word]	
	end 

	def win? 
		if @hide_word == @the_word 
			return true 
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