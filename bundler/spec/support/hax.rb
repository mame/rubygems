# frozen_string_literal: true

module Gem
  def self.ruby=(ruby)
    @ruby = ruby
  end

  if ENV["RUBY"]
    Gem.ruby = ENV["RUBY"]
  end

  if version = ENV["BUNDLER_SPEC_RUBYGEMS_VERSION"]
    remove_const(:VERSION) if const_defined?(:VERSION)
    VERSION = version
  end

  class Platform
    @local = new(ENV["BUNDLER_SPEC_PLATFORM"]) if ENV["BUNDLER_SPEC_PLATFORM"]
  end
  @platforms = [Gem::Platform::RUBY, Gem::Platform.local]

  # We only need this hack for rubygems versions without the BundlerVersionFinder
  if Gem::Version.new(Gem::VERSION) < Gem::Version.new("2.7.0") || ENV["BUNDLER_SPEC_DISABLE_DEFAULT_BUNDLER_GEM"]
    @path_to_default_spec_map.delete_if do |_path, spec|
      spec.name == "bundler"
    end
  end
end

if ENV["BUNDLER_SPEC_VERSION"]
  require_relative "path"
  require "#{Spec::Path.lib_dir}/bundler/version"

  module Bundler
    remove_const(:VERSION) if const_defined?(:VERSION)
    VERSION = ENV["BUNDLER_SPEC_VERSION"].dup
  end
end

if ENV["BUNDLER_SPEC_WINDOWS"] == "true"
  require_relative "path"
  require "#{Spec::Path.lib_dir}/bundler/constants"

  module Bundler
    remove_const :WINDOWS if defined?(WINDOWS)
    WINDOWS = true
  end
end
