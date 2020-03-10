# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

class Search
  extend T::Sig

  sig { params(radar: Radar, invader: Invader).void }
  def initialize(radar, invader)
    @radar = T.let(radar, Radar)
    @invader = T.let(invader, Invader)
  end

  sig { returns(T::Array[{ x: Integer, y: Integer }]) }
  def call
    galaxy_as_lines = @radar.shot.split("\n")
    galaxy_as_matrix = galaxy_as_lines.map { |line| line.split('') }
    col_count = (galaxy_as_lines.first.length - @invader.sizes[:width])
    lines_count = (galaxy_as_lines.length - @invader.sizes[:height])
    invader_map = @invader.pattern.split("\n").map { |l| l.split('') }

    result = {}

    col_count.times do |col_number|
      lines_count.times do |line_number|
        # move me into SearchStrategry
        weight = galaxy_as_matrix[line_number, @invader.sizes[:height]].map.with_index do |line, line_index|
          line[col_number, @invader.sizes[:width]].map.with_index do |symbol, symbol_index|
            invader_map[line_index][symbol_index] == symbol ? 1 : 0
          end
        end.flatten.reduce(:+)

        result[weight] ||= []
        result[weight] << { x: col_number, y: line_number }
        # / move me into SearchStrategry
      end
    end

    result.max.last
  end
end
