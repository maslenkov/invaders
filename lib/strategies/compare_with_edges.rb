# typed: strict
# frozen_string_literal: false

require 'sorbet-runtime'
require_relative './shape'
require_relative './compare'
require_relative './edges_offsets'

module Strategies
  class CompareWithEdges
    extend T::Sig

    sig { params(radar: Radar, invader: Invader).void }
    def initialize(radar, invader)
      @radar = T.let(radar, Radar)
      @invader = T.let(invader, Invader)
    end

    sig { returns(T::Array[{ x: Integer, y: Integer }]) }
    def call
      extender = Strategies::EdgesOffsets.new(@radar, @invader, Strategies::Compare::NOISE_RATE)

      extended_galaxy = extender.add_offset_to_galaxy_shot

      results = Strategies::Compare.new(Radar.new(extended_galaxy), @invader).call

      extender.remove_offset_from_result(results)
    end
  end
end
