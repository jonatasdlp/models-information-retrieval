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
