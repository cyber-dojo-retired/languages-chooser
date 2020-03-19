# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalCreator

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'creator', 4523)
  end

  def ready?
    @http.get(__method__, {})
  end

  def group_create(exercise_name, languages_names)
    @http.post(__method__, {
      exercise_name:exercise_name,
      languages_names:languages_names
    })
  end

  def kata_create(exercise_name, language_name)
    @http.post(__method__, {
      exercise_name:exercise_name,
      language_name:language_name
    })
  end

end
