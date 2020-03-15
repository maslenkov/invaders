# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative './kit/shape'

module Strategies
  class Compare
    extend T::Sig

    NOISE_RATE = 0.73

    sig { params(radar: Radar, invader: Invader).void }
    def initialize(radar, invader)
      @radar = T.let(radar, Radar)
      @invader = T.let(invader, Invader)

      @galaxy_shape = T.let(Strategies::Kit::Shape.new(radar.shot), Strategies::Kit::Shape)
      @invader_shape = T.let(Strategies::Kit::Shape.new(invader.pattern), Strategies::Kit::Shape)
    end

    sig { returns(T::Array[{ x: Integer, y: Integer }]) }
    def call
      reduce_suspects(collect_suspects_by_weights)
    end

    private

    sig do
      params(suspects_grouped_by_weights: T::Hash[Integer, T::Array[{ x: Integer, y: Integer }]])
        .returns(T::Array[{ x: Integer, y: Integer }])
    end
    def reduce_suspects(suspects_grouped_by_weights)
      min_weight = NOISE_RATE * @invader.sizes[:width] * @invader.sizes[:height]
      suspects_grouped_by_weights.each_with_object([]) do |(suspect_weight, coordinates), result|
        result.concat(coordinates) if suspect_weight > min_weight
      end
    end

    sig { returns(T::Hash[Integer, T::Array[{ x: Integer, y: Integer }]]) }
    def collect_suspects_by_weights
      coordinates.each_with_object({}) do |(col_number, line_number), result|
        weight = calculate_weight(col_number, line_number)

        result[weight] ||= []
        result[weight] << { x: col_number, y: line_number }
      end
    end

    sig { params(col_number: Integer, line_number: Integer).returns(Integer) }
    def calculate_weight(col_number, line_number)
      T.must(galaxy_matrix[line_number, @invader.sizes[:height]]).map.with_index do |line, line_index|
        T.must(line[col_number, @invader.sizes[:width]]).map.with_index do |symbol, symbol_index|
          T.must(invader_matrix[line_index])[symbol_index] == symbol ? 1 : 0
        end
      end.flatten.reduce(:+)
    end

    sig { returns(T::Array[[Integer, Integer]]) }
    def coordinates
      result = []
      (0...col_count).map do |col_number|
        (0...lines_count).map do |line_number|
          result << [col_number, line_number]
        end
      end
      result
    end

    sig { returns(Integer) }
    def col_count
      @galaxy_shape.square_matrix_width - @invader.sizes[:width]
    end

    sig { returns(Integer) }
    def lines_count
      @galaxy_shape.square_matrix_height - @invader.sizes[:height]
    end

    sig { returns(T::Array[T::Array[String]]) }
    def galaxy_matrix
      @galaxy_shape.square_matrix
    end

    sig { returns(T::Array[T::Array[String]]) }
    def invader_matrix
      @invader_shape.square_matrix
    end
  end
end
