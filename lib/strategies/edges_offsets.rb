# typed: strict
# frozen_string_literal: false

require 'sorbet-runtime'
require_relative './shape'
require_relative './compare'

module Strategies
  class EdgesOffsets
    extend T::Sig

    sig { params(radar: Radar, invader: Invader).void }
    def initialize(radar, invader)
      @radar = T.let(radar, Radar)

      @invader_shape = T.let(Strategies::Shape.new(invader.pattern), Strategies::Shape)
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

    NOISE_RATE = 0.73
    EDGE_SYMBOL = 'o'

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

    sig { returns(String) }
    def galaxy
      @galaxy ||= ''
    end

    sig { returns(Strategies::Shape) }
    def galaxy_shape
      @galaxy_shape ||= Strategies::Shape.new(@radar.shot)
    end

    sig { returns(Integer) }
    def additional_width
      @additional_width ||= (@invader_shape.square_matrix_width * (1 - NOISE_RATE)).ceil
    end

    sig { returns(Integer) }
    def additional_height
      @additional_height ||= (@invader_shape.square_matrix_height * (1 - NOISE_RATE)).ceil
    end
  end
end
