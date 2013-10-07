# encoding: utf-8
require 'vidibus/core_extensions'
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
 
class Vocabulary
 
	def initialize(documents)
		@documents = documents
		@words = get_words
	end
 
	def build_vocabulary
		vocabulary = []
		process_vocabulary.each do |key, value|
			vocabulary.push({id: generate_id(key), value: key, df: value})
		end
 
		vocabulary
	end
 
	def inverted_index()
		l = []
		h = []
		nw = []
		index = []
		full_index = []
 
		build_vocabulary.map { |e| l.push(e[:value]) if e[:value] != "" }
 
		@documents.each do |k, v|
			l.each do |z|
				h.push({id: k, term: z, ocrr: v.to_s.split(/,|\?|\s/).each_with_index.map { |a, i| a.latinize == z ? i + 1 : nil }.compact})
			end
		end
 
		h.each do |r|
			build_vocabulary.each do |t|
				if (r[:ocrr] != []) && (r[:term] == t[:value])
					nw.push(r)
				end
			end
		end
 
		y =  nw.group_by {|d| d[:term] }
 
		y.each do |m, n|
			#print m.to_s + " => "
			n.each do |b|
				index.push({document: b[:id].to_s, df: b[:ocrr].count.to_s, ocurrency: b[:ocrr].to_s})
			end
			full_index.push(Index.new(m.to_s, index))
			index = []
		end
 
		full_index
	end
 
 
	def get_words
		terms = []
		@documents.each do |key, value|
			value.to_s.split(/,|\?|\s/).each do |w|
				term = w.latinize
				terms.push(term)
			end
		end 
 
		terms
	end
 
	def get_words_by_document(document)
    terms = []
		document.to_s.split(/,|\?|\s/).each do |w|
		  term = w.latinize
			terms.push(term) if term != ""
		end 
		terms
	end 
 
	def process_vocabulary
		index = Hash.new
		@words.each { | v | index.store(v, index[v].to_i + 1) }
		index
	end
 
	def generate_id(word)
		code = ""
		word.each_byte{|p| code += p.to_s}
		code
	end
end
 
documents = {
	:D1 => "lucene é um sistema de recuperação de informação, não de dados",
	:D2 => "quicksort é um algoritmo de ordenação de dados usado em banco de dados",
	:D3 => "os banco de dados relacionais armazenam e recuperam informação" ,
	:D4 => "em um projeto de algoritmos estruturas de dados são fundamentais",
	:D5 => "qual o melhor algoritmo para recuperação de dados?",
	:D6 => "o modelo vetorial é um modelo usado em sistemas de recuperação de informação",
	:D7 => "os dados manipulados por bancos de dados são estáticos",
	:D8 => "o que se estuda em projeto e análise de algoritmos e estrutura de dad"
}
 
#a = File.open('teste.html', 'r')
v = Vocabulary.new(documents)
#puts v.build_vocabulary
 
documents.each do |k, x|
  puts v.get_words_by_document(x.to_s).include?("recuperacao") && (v.get_words_by_document(x.to_s).include?("informacao") || !v.get_words_by_document(x.to_s).include?("dados") )
end


#hash = Hash[).map.with_index.to_a]
#puts documents[:D1].to_s.split(/,|\?|\s/)
 
#puts v.index_frequency("o")
#v.inverted_index.each do |t|
# puts t.word.to_s + " " + t.location.to_s
#end
