require 'httparty'

class GamesController < ApplicationController
  VOWELS = %w[A E I O U]

  def new
    @letters = (Array.new(10 - VOWELS.length) { ('A'..'Z').to_a.sample } + VOWELS).shuffle
  end

  def score
    valid_word = check_word_validty(params[:word])

    if valid_word
      session[:score] ||= []
      session[:score] += params[:word].length
      @result = 'You got it'
    else
      @result = 'Not an English word, sorry'
    end
  end

  def calculate_grand_total
    (session[:score] || []).succ
  end
  helper_method :calculate_grand_total


  private

  def check_word_validty(word)
    response = HTTParty.get("https://wagon-dictionary.herokuapp.com/#{word}")
    json_response = JSON.parse(response.body)
    json_response['found']
  end
end
