# typed: strict
# frozen_string_literal: true

require 'bundler/setup'
require 'sorbet-runtime'

class Radar
  extend T::Sig

  sig { returns(String) }
  attr_reader :shot

  sig { params(snapshot: String).void }
  def initialize(snapshot)
    @shot = T.let(snapshot, String)
  end
end
