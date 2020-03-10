# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

class Invader
  extend T::Sig

  sig { params(invader_pattern_file_path: String).void }
  def initialize(invader_pattern_file_path)
    @pattern = T.let(File.read(invader_pattern_file_path), String)
    @sizes = T.let(nil, T.nilable({ width: Integer, height: Integer }))
    @pattern_by_lines = T.let(nil, T.nilable(T::Array[String]))
  end

  sig { returns(String) }
  attr_reader :pattern

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
