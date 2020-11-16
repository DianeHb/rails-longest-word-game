require "json"
require "open-uri"


class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @grid = params[:letters].split(',')
    @word_split = params[:word].upcase.split('')

    # The word can’t be built out of the original grid
    unless @word_split.all? { |letter| @word_split.count(letter) <= @grid.count(letter) }
      return @message = "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters]}"
    end
    # The word is valid according to the grid, but is not a valid English word
    return @message = "Sorry but #{params[:word].upcase} isn't an english word" unless english_word?(params[:word])
    # The word is valid according to the grid and is an English word
    @message = "Congratulations ! #{params[:word].upcase} is a valid English word"
    game_score = params[:word].length

    if session[:total_score].nil?
      session[:total_score] = game_score
    else
      session[:total_score] += game_score
    end

  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url)
    json = JSON.parse(response.read)
    return json['found']==true
  end
end
