# Jonatas Santos

require 'vidibus/core_extensions'
require 'nokogiri'
require 'action_view'
require 'sanitize'
require 'stopwords'
include ActionView::Helpers::SanitizeHelper

class Vocabulary

  attr_accessor :K, :b, :N, :avg

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

  # count document words
  def get_words_by_document(document)
    terms = []
    document.to_s.split(/,|\?|\s/).each do |w|
      term = w.latinize
      terms.push(term) if term != ""
    end
    terms
  end

  def self.get_words_by_document(document)
    terms = []
    document.to_s.split(/,|\?|\s/).each do |w|
      term = w.latinize
      terms.push(term) if term != ""
    end
    terms
  end

  def self.count_words_in_document(doc, word)
    cont = 0
    doc.to_s.split(/,|\?|\s/).each do |w|
      term = w.latinize
      wr = word.latinize
      if (term != "") && (term == wr)
        cont += 1
      end
    end
    cont
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

  def term_document_count(word)
    cont = 0
    @documents.each do |k, v|
      self.get_words_by_document(v).include?(word) ? cont += 1 : cont
    end
    cont
  end

  def calc_idf(word)
    idf = Math.log2(@documents.count/term_document_count(word).to_f)
  end

  def calc_tf(word)
    values = []
    @documents.each do |k, v|
      hash = Hash.new(0)
      self.get_words_by_document(v).each { |q| hash.store(q, hash[q] + 1) if q == word }
      values.push((hash[word].to_i > 0) ? (1 + Math.log2(hash[word].to_i)) : 0)
    end
    values
  end

  def calc_idf_term(doc, term)
    cont = 0
    doc.split(' ').map{|c| cont += 1 if c == term}
    ((1 + Math.log2(cont))*self.calc_idf(term)).round(4)
  end

  def calc_similarity(v)
    values = {}
    v.split(' ').each do |i|
      values[i] = values[i] = []
      self.calc_tf(i).each do |p|
        values[i] << (tf_t = (p * self.calc_idf(i)).round(4))
      end
      values[i] << (tf_q = calc_idf_term(v, i))
    end
    values
  end

  # generate hash
  def occurrence_in_documents(word)
    hash = Hash.new(0)
    @documents.each do |k, v|
      self.get_words_by_document(v).uniq.each { |q| hash.store(q, hash[q] + 1) if q == word }
    end
    hash[word].to_i
  end

  def occurrence_in_document(word, doc)
    cont = 0
    @documents.each do |k, v|
      if doc == k
        get_words_by_document(v).each do |w|
          if w == word
            cont = cont + 1
          end
        end
      end
    end
    cont
  end

  def occurrence_in_document_key(key, word, doc)
    cont = 0
    @documents.each do |k, v|
      if key == k
        get_words_by_document(v).each do |w|
          if w == word
            cont = cont + 1
          end
        end
      end
    end
    cont
  end

  def probabilistic(key, word, doc)
    term_count = self.term_document_count(word)
    # 8 == all docs
    self.occurrence_in_document_key(key, word, doc) > 0 ? Math.log10((8 - term_count + 0.5) /(term_count + 0.5)) : 0
  end

  def probabilistic_next(key, word, doc, rel_a, rel_b)
    docs = 8
    r_in_coll = 4
    self.occurrence_in_document_key(key, word, doc) > 0 ?                                  
    Math.log(((rel_a.to_f + 0.5)/(r_in_coll - rel_b.to_f + 0.5).to_f) * ((docs - rel_b.to_f - r_in_coll.to_f + rel_a.to_f + 0.5)/((rel_a.to_f - rel_b.to_f) + 0.5)).to_f) : 0
  end

  def self.query_in_documents(query, documents)
    q = query.split(' ')
    cont = 0
    documents.each do |k, v|
      if Vocabulary.get_words_by_document(v).include?(q[0]) && get_words_by_document(v).include?(q[1]) && get_words_by_document(v).include?(q[2])
        cont = cont + 1
      end
    end
    cont
  end

  def self.calc_term_bm(term, doc)
    k = 1 # Constant
    b = 0.75 # default
    avg =	10.88 # avg documents
    x = Vocabulary.count_words_in_document(doc, term).to_i || 0
    l = Vocabulary.get_words_by_document(doc).count.to_i || 0
    ((k+1)*x/(k*((1-b)+b*(l/avg))+x))
  end

  def calc_sim_bm(term, doc)
    n = 8 # all documents
    z = Vocabulary.calc_term_bm(term,doc)
    x = term_document_count(term) || 0
    (z * Math.log10((n - x + 0.5)/(x + 0.5)))
  end
end
