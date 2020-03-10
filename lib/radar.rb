# typed: strict
# frozen_string_literal: true

require 'bundler/setup'
require 'sorbet-runtime'

class Radar
  extend T::Sig

  sig { returns(String) }
  attr_reader :shot

  sig { params(galaxy_file_path: String).void }
  def initialize(galaxy_file_path)
    @shot = T.let(File.read(galaxy_file_path), String)
  end
end
