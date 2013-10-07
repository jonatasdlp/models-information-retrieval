class AppController < ApplicationController
  def index
    @documents = {
      :D1 => "lucene é um sistema de recuperação de informação, não de dados",
      :D2 => "quicksort é um algoritmo de ordenação de dados usado em banco de dados",
      :D3 => "os banco de dados relacionais armazenam e recuperam informação" ,
      :D4 => "em um projeto de algoritmos estruturas de dados são fundamentais",
      :D5 => "qual o melhor algoritmo para recuperação de dados?",
      :D6 => "o modelo vetorial é um modelo usado em sistemas de recuperação de informação",
      :D7 => "os dados manipulados por bancos de dados são estáticos",
      :D8 => "o que se estuda em projeto e análise de algoritmos e estrutura de dad"
    }

    @vocabulary = Vocabulary.new(@documents)
  end
  
  def show
    @documents = {
      :D1 => "lucene é um sistema de recuperação de informação, não de dados",
      :D2 => "quicksort é um algoritmo de ordenação de dados usado em banco de dados",
      :D3 => "os banco de dados relacionais armazenam e recuperam informação" ,
      :D4 => "em um projeto de algoritmos estruturas de dados são fundamentais",
      :D5 => "qual o melhor algoritmo para recuperação de dados?",
      :D6 => "o modelo vetorial é um modelo usado em sistemas de recuperação de informação",
      :D7 => "os dados manipulados por bancos de dados são estáticos",
      :D8 => "o que se estuda em projeto e análise de algoritmos e estrutura de dad"
    }

    @vocabulary = Vocabulary.new(@documents)
  end

  def boolean
  end

  def vetorial
  end
end
