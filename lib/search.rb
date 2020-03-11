# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

class Search
  extend T::Sig

  sig { params(radar: Radar, invader: Invader).void }
  def initialize(radar, invader)
    @radar = T.let(radar, Radar)
    @invader = T.let(invader, Invader)

    @galaxy_as_lines = T.let(nil, T.nilable(T::Array[String]))
    @galaxy_as_matrix = T.let(nil, T.nilable(T::Array[T::Array[String]]))
    @col_count = T.let(nil, T.nilable(Integer))
    @lines_count = T.let(nil, T.nilable(Integer))
    @invader_matrix = T.let(nil, T.nilable(T::Array[T::Array[String]]))
  end

  sig { returns(T::Array[{ x: Integer, y: Integer }]) }
  def call
    reduce_suspects(collect_suspects_by_weights)
  end

  private

  # TODO: move me into SearchStrategy
  RATE = 0.75

  sig do
    params(suspects_grouped_by_weights: T::Hash[Integer, T::Array[{ x: Integer, y: Integer }]])
      .returns(T::Array[{ x: Integer, y: Integer }])
  end
  def reduce_suspects(suspects_grouped_by_weights)
    rate = RATE * @invader.sizes[:width] * @invader.sizes[:height]
    suspects_grouped_by_weights.each_with_object([]) do |(suspect_weight, coordinates), result|
      result.concat(coordinates) if suspect_weight > rate
    end
  end

  sig { returns(T::Hash[Integer, T::Array[{ x: Integer, y: Integer }]]) }
  def collect_suspects_by_weights
    result = {}

    col_count.times do |col_number|
      lines_count.times do |line_number|
        weight = T.must(galaxy_as_matrix[line_number, @invader.sizes[:height]]).map.with_index do |line, line_index|
          T.must(line[col_number, @invader.sizes[:width]]).map.with_index do |symbol, symbol_index|
            T.must(invader_matrix[line_index])[symbol_index] == symbol ? 1 : 0
          end
        end.flatten.reduce(:+)

        result[weight] ||= []
        result[weight] << { x: col_number, y: line_number }
      end
    end
    result
  end

  sig { returns(Integer) }
  def col_count
    @col_count ||= (T.must(galaxy_as_lines.first).length - @invader.sizes[:width])
  end

  sig { returns(Integer) }
  def lines_count
    @lines_count ||= (galaxy_as_lines.length - @invader.sizes[:height])
  end

  sig { returns(T::Array[T::Array[String]]) }
  def galaxy_as_matrix
    @galaxy_as_matrix ||= galaxy_as_lines.map { |line| line.split('') }
  end

  sig { returns(T::Array[T::Array[String]]) }
  def invader_matrix
    @invader_matrix ||= @invader.pattern.split("\n").map { |l| l.split('') }
  end

  sig { returns(T::Array[String]) }
  def galaxy_as_lines
    @galaxy_as_lines ||= @radar.shot.split("\n")
  end
  # / move me into SearchStrategy
end
