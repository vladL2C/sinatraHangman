require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

  get '/' do
  	start_game
  	@turns_left = session[:turns_left] 
  	@used_letters = session[:used_letters]
  	@the_word = session[:the_word]
  	@hide_word = session[:hide_word]
  	redirect '/play'
  end

  get '/play' do
  	@turns_left = session[:turns_left] 
  	@used_letters = session[:used_letters]
  	@the_word = session[:the_word]
  	@hide_word = session[:hide_word]
  	erb :index
  end

  post '/play' do
  	turns
  	@turns_left = session[:turns_left] 
  	@used_letters = session[:used_letters]
  	@the_word = session[:the_word]
  	@hide_word = session[:hide_word]
  	correct_letter?(params['letter'])

  	if win? 
  		redirect '/win'
  	end 

  	if lose?
  		redirect '/lose'
  	end 

  	erb :index
  end 

  get '/win' do 
  	@the_word = session[:the_word]
  erb :win	
  end

  get '/lose' do
  	@the_word = session[:the_word]
  	erb :lose
  end 

helpers do

  def start_game 
		session[:used_letters] = []
		session[:turns_left] = 8
		session[:the_word] = generate_word
		session[:hide_word] = secret_word		
	end 
  
	def turns 
		if !session[:the_word].include?(params['letter'])   
			session[:turns_left] -= 1  	
		end
	end

	def lose?
		if @turns_left == 0 
			return true 
		end 
	end   

	def win? 
		if @hide_word == @the_word 
			return true 
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
		if @used_letters.include?(letter)
			@msg = "Its already there"
			else 
			@used_letters.push(letter)
			end 	
	end 



end