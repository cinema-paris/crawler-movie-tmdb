require 'active_support/core_ext/object/blank'
require 'crawler/movie/providers/tmdb/configuration'
require 'crawler/movie'
require 'date'
require 'faraday'
require 'json'

module Crawler
  module Movie
    module Providers
      module Tmdb
        include Crawler::Api

        API_URL = 'https://api.themoviedb.org'
        CDN_URL = 'https://image.tmdb.org'

        def self.search(query)
          movies = []
          current_page = 1

          loop do
            response = connection.get('/3/search/movie',
              api_key: config.api_key,
              language: config.language,
              query: query,
              page: current_page,
              include_adult: config.include_adult,
              region: config.region
            )

            break if !response.success? || !response.body

            results = response.body['results'].map do |movie|
              {
                id: movie['id'],
                source: 'the-movie-database',
                title: movie['title'],
                poster_url: movie['poster_path'].presence && "#{CDN_URL}/t/p/original#{movie['poster_path']}",
                backdrop_url: movie['backdrop_path'].presence && "#{CDN_URL}/t/p/original#{movie['backdrop_path']}",
                original_languages: movie['original_language'].present? ? [movie['original_language']] : [],
                original_title: movie['original_title'].presence,
                genres: movie['genre_ids'],
                overview: movie['overview'].presence,
                release_date: movie['release_date'].present? && Date.parse(movie['release_date'])
              }
            end

            movies.concat(results)

            break if current_page >= response.body['total_pages']

            current_page += 1
          end

          movies
        end
      end
    end
  end
end

Crawler::Movie.add_provider :tmdb, score: 0.95
