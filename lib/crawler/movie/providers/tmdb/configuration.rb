require 'active_support/core_ext/module/attribute_accessors'

module Crawler
  module Movie
    module Providers
      module Tmdb
        mattr_accessor :api_key

        mattr_accessor :region
        @@region = 'FR'

        mattr_accessor :language
        @@language = 'fr-FR'

        mattr_accessor :include_adult
        @@include_adult = false

        def self.configure
          yield self
        end
      end
    end
  end
end
