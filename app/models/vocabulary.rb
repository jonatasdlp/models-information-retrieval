# Jonatas Santos

require 'vidibus/core_extensions'
require 'nokogiri'
require 'action_view'
require 'sanitize'
require 'stopwords'
include ActionView::Helpers::SanitizeHelper

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
