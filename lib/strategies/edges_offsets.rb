# typed: strict
# frozen_string_literal: false

require 'sorbet-runtime'
require_relative './shape'

module Strategies
  class EdgesOffsets
    extend T::Sig

    sig { params(radar: Radar, invader: Invader, noise_rate: Float).void }
    def initialize(radar, invader, noise_rate)
      @galaxy_shape = T.let(Strategies::Shape.new(radar.shot), Strategies::Shape)
      @invader_shape = T.let(Strategies::Shape.new(invader.pattern), Strategies::Shape)
      @galaxy = T.let('', String)

      @additional_width = T.let(nil, T.nilable(Integer))
      @additional_height = T.let(nil, T.nilable(Integer))
      @noise_rate = T.let(noise_rate, Float)
    end

    sig { returns(String) }
    def add_offset_to_galaxy_shot
      extend_galaxy_shot_with_edges
    end

    sig do
      params(results: T::Array[{ x: Integer, y: Integer }])
        .returns(T::Array[{ x: Integer, y: Integer }])
    end
    def remove_offset_from_result(results)
      results.map do |result|
        {
          x: result[:x] - additional_width,
          y: result[:y] - additional_height
        }
      end
    end

    private

    EDGE_SYMBOL = T.let('o'.freeze, String)

    sig { returns(String) }
    attr_reader :galaxy

    sig { returns(Strategies::Shape) }
    attr_reader :galaxy_shape

    sig { returns(String) }
    def extend_galaxy_shot_with_edges
      add_vertical_offset
      add_horizontal_offset
      add_vertical_offset
      galaxy
    end

    sig { void }
    def add_horizontal_offset
      galaxy_shape.square_matrix_height.times do |line_number|
        galaxy << EDGE_SYMBOL * additional_width
        galaxy << galaxy_shape.lines[line_number]
        galaxy << EDGE_SYMBOL * additional_width
        galaxy << "\n"
      end
    end

    sig { void }
    def add_vertical_offset
      additional_height.times do
        galaxy << EDGE_SYMBOL * (additional_width * 2 + galaxy_shape.square_matrix_width)
        galaxy << "\n"
      end
    end

    sig { returns(Integer) }
    def additional_width
      @additional_width ||= (@invader_shape.square_matrix_width * (1 - @noise_rate)).ceil
    end

    sig { returns(Integer) }
    def additional_height
      @additional_height ||= (@invader_shape.square_matrix_height * (1 - @noise_rate)).ceil
    end
  end
end
