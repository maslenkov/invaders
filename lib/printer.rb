# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative 'strategies/compare_with_edges'

class Printer
  extend T::Sig

  sig { params(radar: Radar, invader: Invader).void }
  def initialize(radar, invader)
    @radar = T.let(radar, Radar)
    @invader = T.let(invader, Invader)

    @galaxy_shape = T.let(Strategies::Kit::Shape.new(radar.shot), Strategies::Kit::Shape)
    @invader_shape = T.let(Strategies::Kit::Shape.new(invader.pattern), Strategies::Kit::Shape)
    @galaxy_matrix = T.let(nil, T.nilable(T::Array[T::Array[String]]))
    @invader_matrix = T.let(nil, T.nilable(T::Array[T::Array[String]]))
    @lines_count = T.let(nil, T.nilable(Integer))
    @col_count = T.let(nil, T.nilable(Integer))
  end

  sig { void }
  def call
    draw(Strategies::CompareWithEdges.new(@radar, @invader).call)
  end

  private

  sig { params(coordinates: T::Array[{ x: Integer, y: Integer }]).void }
  def draw(coordinates)
    res = galaxy_matrix
    coordinates.each do |c|
      highlight_results(c, res)
    end
    puts res.map { |line| line.join('') }.join("\n")
  end

  sig { params(coordinates: { x: Integer, y: Integer }, res: T::Array[T::Array[String]]).void }
  def highlight_results(coordinates, res)
    y      = get_block_y(coordinates[:y])
    offset = get_block_offset(coordinates[:y])
    height = get_block_height(coordinates[:y])
    T.must(galaxy_matrix[y, height]).each.with_index do |line, line_index|
      T.must(line[coordinates[:x], @invader.sizes[:width]]).each.with_index do |galaxy_symbol, symbol_index|
        invader_symbol = T.must(invader_matrix[line_index + offset])[symbol_index]
        T.must(res[y + line_index])[coordinates[:x] + symbol_index] = highlight_symbol(T.must(invader_symbol), galaxy_symbol)
      end
    end
  end

  sig { params(invader_symbol: String, galaxy_symbol: String).returns(String) }
  def highlight_symbol(invader_symbol, galaxy_symbol)
    if invader_symbol == galaxy_symbol
      "\e[35m#{galaxy_symbol}\e[0m"
    else
      galaxy_symbol == 'o' ? "\e[31m-\e[0m" : "\e[31mo\e[0m"
    end
  end

  sig { params(y: Integer).returns(Integer) }
  def get_block_height(y)
    y >= 0 ? @invader.sizes[:height] : @invader.sizes[:height] + y
  end

  sig { params(y: Integer).returns(Integer) }
  def get_block_offset(y)
    y >= 0 ? 0 : -y
  end

  sig { params(y: Integer).returns(Integer) }
  def get_block_y(y)
    y >= 0 ? y : 0
  end

  sig { returns(Integer) }
  def col_count
    @col_count ||= (@galaxy_shape.square_matrix_width - @invader.sizes[:width])
  end

  sig { returns(Integer) }
  def lines_count
    @lines_count ||= (@galaxy_shape.square_matrix_height - @invader.sizes[:height])
  end

  sig { returns(T::Array[T::Array[String]]) }
  def galaxy_matrix
    @galaxy_matrix ||= @galaxy_shape.square_matrix
  end

  sig { returns(T::Array[T::Array[String]]) }
  def invader_matrix
    @invader_matrix ||= @invader_shape.square_matrix
  end
end
