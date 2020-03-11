# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

class Search
  extend T::Sig

  sig { params(radar: Radar, invader: Invader, strategy: T.class_of(Strategies::Compare)).void }
  def initialize(radar, invader, strategy)
    @radar = T.let(radar, Radar)
    @invader = T.let(invader, Invader)

    @strategy = T.let(strategy, T.class_of(Strategies::Compare))
  end

  sig { returns(T::Array[{ x: Integer, y: Integer }]) }
  def call
    @strategy.new(@radar, @invader).call
  end
end
