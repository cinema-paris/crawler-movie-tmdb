require 'crawler/movie/providers/tmdb/configuration'
require 'crawler/movie'
require 'faraday'
require 'json'
require 'active_support/core_ext/object/blank'
require 'date'

module Crawler
  module Movie
    module Providers
      module Tmdb
        def self.search(query)
          movies = []
          current_page = 1

          loop do
            response = Faraday.get('https://api.themoviedb.org/3/search/movie',
              api_key: api_key,
              language: language,
              query: query,
              page: current_page,
              include_adult: include_adult,
              region: region
            )

            break if !response.success? || !response.body

            json = JSON.parse(response.body)
            results = json['results'].map do |movie|
              {
                id: movie['id'],
                source: 'the-movie-database',
                title: movie['title'],
                poster_url: movie['poster_path'].present? && "https://image.tmdb.org/t/p/original#{movie['poster_path']}",
                backdrop_url: movie['backdrop_path'].present? && "https://image.tmdb.org/t/p/original#{movie['backdrop_path']}",
                original_languages: movie['original_language'].present? ? [movie['original_language']] : [],
                original_title: movie['original_title'].presence,
                genres: movie['genre_ids'],
                overview: movie['overview'].presence,
                release_date: movie['release_date'].present? && Date.parse(movie['release_date'])
              }
            end

            movies.concat(results)

            break if current_page >= json['total_pages']

            current_page += 1
          end

          movies
        end
      end
    end
  end
end

Crawler::Movie.add_provider :tmdb, score: 0.95
