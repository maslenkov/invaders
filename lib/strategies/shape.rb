# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

module Strategies
  class Shape
    extend T::Sig

    sig { params(pattern: String).void }
    def initialize(pattern)
      @pattern = T.let(pattern, String)

      @square_matrix = T.let(nil, T.nilable(T::Array[T::Array[String]]))
      @square_matrix_width = T.let(nil, T.nilable(Integer))
      @square_matrix_height = T.let(nil, T.nilable(Integer))
    end

    sig { returns(T::Array[T::Array[String]]) }
    def square_matrix
      @square_matrix ||= @pattern.split("\n").map { |l| l.split('') }
    end

    sig { returns(Integer) }
    def square_matrix_width
      @square_matrix_width ||= T.must(square_matrix.first).length
    end

    sig { returns(Integer) }
    def square_matrix_height
      @square_matrix_height ||= square_matrix.length
    end
  end
end
