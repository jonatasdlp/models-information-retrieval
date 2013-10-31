# encoding: utf-8

class AppController < ApplicationController


  def index
    base
  end

  def inverted_list
    base
  end

  def vocabulary
    base
  end

  def boolean
    base
    @result_first = query_first
    @result_second = query_second
    @result_third = query_third
  end

  def term_frequency
    base
  end

  def inverse_document_frequency
    base
  end

  def vetorial
    base
  end

  def vector_sim
    base
    @queries = {q1: "recuperacao de informacao", q2: "banco de dados", q3: "projeto de algoritmo"}
  end

  def probabilistic
    base
    @queries = {q1: "recuperacao de informacao", q2: "banco de dados", q3: "projeto de algoritmo"}
    @params = [[[3,8,3],[3,4,3],[3,4,3]],[[2,8,7],[2,4,4],[2,4,4]],[[2,8,2],[2,4,2],[2,4,2]]]
  end

  def bm_25
    base
    @queries = {q1: "recuperacao de informacao", q2: "banco de dados", q3: "projeto de algoritmo"}
  end

  def term_list
    bm_25
  end

  def sim_terms
    bm_25
  end

  def calc_terms
    bm_25
  end

  def rank_terms
    bm_25
  end

  private

  def base
    @documents = {
      :D1 => "lucene é um sistema de recuperação de informação, não de dados",
      :D2 => "quicksort é um algoritmo de ordenação de dados usado em banco de dados",
      :D3 => "os banco de dados relacionais armazenam e recuperam informação" ,
      :D4 => "em um projeto de algoritmos estruturas de dados são fundamentais",
      :D5 => "qual o melhor algoritmo para recuperação de dados?",
      :D6 => "o modelo vetorial é um modelo usado em sistemas de recuperação de informação",
      :D7 => "os dados manipulados por bancos de dados são estáticos",
      :D8 => "o que se estuda em projeto e análise de algoritmos e estrutura de dados"
    }

    @vocabulary = Vocabulary.new(@documents)
  end

  def query_first
    base
    result = []
    @documents.each do |k, v|
      status = @vocabulary.get_words_by_document(v.to_s).include?("recuperacao") && (@vocabulary.get_words_by_document(v.to_s).include?("informacao") || !@vocabulary.get_words_by_document(v.to_s).include?("dados") )
      result.push({document: k, presence: status})
    end
    result
  end

  def query_second
    base
    result = []
    @documents.each do |k, v|
      status = (@vocabulary.get_words_by_document(v.to_s).include?("banco") && @vocabulary.get_words_by_document(v.to_s).include?("dado")) || @vocabulary.get_words_by_document(v.to_s).include?("informacao") 
      result.push({document: k, presence: status})
    end
    result
  end

  def query_third
    base
    result = []
    @documents.each do |k, v|
      status = @vocabulary.get_words_by_document(v.to_s).include?("algoritmo") && !@vocabulary.get_words_by_document(v.to_s).include?("sistema")
      result.push({document: k, presence: status})
    end
    result
  end

end
