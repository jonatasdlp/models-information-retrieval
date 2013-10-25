# Jonatas Santos

require 'nokogiri'
require 'action_view'
require 'sanitize'
require 'stopwords'
include ActionView::Helpers::SanitizeHelper

class Index
  attr_reader :word, :location
 
  def initialize(word, location)
    @word = word
    @location = location
  end
  
  def ==(other)
    self.class === other and
      other.word == @word and
      other.location == @location
  end
 
  alias eql? ==
 
  def hash
    @word.hash ^ @location.hash # XOR
  end
end
 
