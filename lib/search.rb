# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

class Search
  extend T::Sig

  StrategyClass = T.type_alias do
    T.any(
      T.class_of(Strategies::Compare),
      T.class_of(Strategies::CompareWithEdges)
    )
  end

  sig { params(radar: Radar, invader: Invader, strategy: StrategyClass).void }
  def initialize(radar, invader, strategy)
    @radar = T.let(radar, Radar)
    @invader = T.let(invader, Invader)

    @strategy = T.let(strategy, StrategyClass)
  end

  sig { returns(T::Array[{ x: Integer, y: Integer }]) }
  def call
    @strategy.new(@radar, @invader).call
  end
end
