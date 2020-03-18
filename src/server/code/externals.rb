# frozen_string_literal: true
require_relative 'external_creator'
require_relative 'external_languages_start_points'
require_relative 'external_http'

class Externals

  def creator
    @creator ||= ExternalCreator.new(creator_http)
  end
  def creator_http
    @creator_http ||= ExternalHttp.new
  end

  def languages_start_points
    @languages_start_points ||= ExternalLanguagesStartPoints.new(languages_start_points_http)
  end
  def languages_start_points_http
    @languages_start_points_http ||= ExternalHttp.new
  end

end
