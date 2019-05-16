require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet.sample }
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    @answer = params[:word].upcase
    @letters = params[:letters].upcase.split('')
    results = run_game(@answer, @letters, DateTime.parse(params[:start_time]).to_datetime, end_time)
    @score = results[:score]
    @time = results[:time].round
    @message = results[:message]
  end

  private

  def word_in_grid?(word, grid)
    answer = true
    word.upcase.split('').each do |letter|
      grid.include?(letter) ? grid.delete_at(grid.index(letter)) : answer = false
    end
    answer
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    word_infos = JSON.parse(open(url).read)
    guess_time = end_time - start_time
    if word_infos['found']
      if word_in_grid?(attempt, grid)
        score = (attempt.length * 10.fdiv(guess_time)).round
        message = "well done !!"
      else
        message = "the given word is not in the grid"
      end
    else
      message = 'the given word is not an english word'
    end
    { score: score || 0, time: guess_time, message: message }
  end
end
