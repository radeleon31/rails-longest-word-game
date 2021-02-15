require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    # The word can’t be built out of the original grid
    # The word is valid according to the grid, but is not a valid English word
    # The word is valid according to the grid and is an English word
    # grid = "letters in the grid) not equal to give word"
    @letters = params[:letters].split
    @answer = params[:word]
    included = included?(@letters, @answer)

    if included
      if english_word
        @result = " YAY! #{@answer} is a valid according to the grid and is an English word."
      else
        @result = "#{@answer} is valid according to the grid, but is not a valid English word."
      end
    else
      @result = " YAY! #{@answer} is a valid according to the grid and is an English word."
    end
  end

  private

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    return word['found']
  end

  def included?(letters, answer)
    answer.chars.all? do |letter|
      answer.count(letter) <= letters.count(letter)
    end
  end
end
