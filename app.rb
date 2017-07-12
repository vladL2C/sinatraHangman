require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

  get '/' do
  	start_game
  	@the_word = session[:the_word]
  	@hide_word = session[:hide_word]
  	redirect '/play'
  end

  get '/play' do
  	@the_word = session[:the_word]
  	@hide_word = session[:hide_word]
  	erb :index
  end

  post '/play' do 
  	@the_word = session[:the_word]
  	@hide_word = session[:hide_word]
  	correct_letter?(params['letter'])
  	erb :index
  end 

helpers do

  def start_game 
		#@used_letters = []
		#@turns_left = 0
		session[:the_word] = generate_word
		session[:hide_word] = secret_word		
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
		session[:hide_word] = Array.new(session[:the_word].size,"_")
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