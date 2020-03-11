# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

class Invader
  extend T::Sig

  sig { returns(String) }
  attr_reader :pattern

  sig { params(pattern: String).void }
  def initialize(pattern)
    @pattern = T.let(pattern, String)

    @sizes = T.let(nil, T.nilable({ width: Integer, height: Integer }))
    @pattern_by_lines = T.let(nil, T.nilable(T::Array[String]))
  end

  sig { returns({ width: Integer, height: Integer }) }
  def sizes
    @sizes ||= {
      width: T.must(pattern_by_lines.first).length,
      height: pattern_by_lines.count
    }
  end

  private

  sig { returns(T::Array[String]) }
  def pattern_by_lines
    @pattern_by_lines ||= @pattern.split("\n")
  end
end
