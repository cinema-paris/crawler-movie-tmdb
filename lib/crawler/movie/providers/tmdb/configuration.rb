require 'crawler/configuration'

module Crawler
  module Movie
    module Providers
      module Tmdb
        include Crawler::Configuration

        class Configuration
          attr_accessor :api_key, :region, :language, :include_adult

          def initialize
            self.region = 'FR'
            self.language = 'fr-FR'
            self.include_adult = false
          end
        end
      end
    end
  end
end
