# frozen_string_literal: true
require_relative 'test_base'
require_relative 'external_saver'
require_relative 'id_pather'
require_src 'external_http'
require 'json'

class CreateTest < TestBase

  def self.id58_prefix
    'v42'
  end

  def id58_setup
    @exercise_name = 'Fizz Buzz'
    @language_name = languages_names.sample
  end

  attr_reader :exercise_name, :language_name

  # - - - - - - - - - - - - - - - - -
  # group_create
  # - - - - - - - - - - - - - - - - -

  test 'w9A', %w(
  |GET /group_create?exercise_names=X&languages_names[]=Y
  |where X is the name of an exercises-start-point
  |where Y is the name of a languages-start-point
  |redirects to /kata/group/:id page
  |and a group-exercise with :id exists
  ) do
    get '/group_create', {
      exercise_name:exercise_name,
      languages_names:[language_name]
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/group/xCSKgZ
    assert %r"http://example.org/kata/group/(?<id>.*)" =~ url, url
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9C', %w(
  |POST /group_create
  |with body containing exercise-name and languages_names
  |returns json payload
  |with {"group_create":"ID"}
  |where a group with ID exists
  ) do
    json_post path='group_create', {
      exercise_name:exercise_name,
      languages_names:[language_name]
    }
    assert status?(200), status
    assert json_content?, content_type
    assert_equal [path], json_response.keys.sort, :keys
    id = json_response[path] # eg xCSKgZ
    assert group_exists?(id), "id:#{id}:"
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], :exercise
  end

  # - - - - - - - - - - - - - - - - -
  # kata_create
  # - - - - - - - - - - - - - - - - -

  test 'w9B', %w(
  |GET /kata_create?exercise_name=X&language_name=Y
  |where X is the name of an exercises-start-point
  |where Y is the name of a languages-start-point
  |redirects to /kata/edit/:id page
  |and an individual-exercise with :id exists
  ) do
    get '/kata_create', {
      exercise_name:exercise_name,
      language_name:language_name
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/edit/H3Nqu2
    assert %r"http://example.org/kata/edit/(?<id>.*)" =~ url, url
    assert kata_exists?(id), "id:#{id}:" # eg H3Nqu2
    manifest = kata_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9D', %w(
  |POST /kata_create
  |with body containing exercise-name and languages_names
  |returns json payload
  |with {"kata_create":"ID"}
  |where a kata with ID exists
  ) do
    json_post path='kata_create', {
      exercise_name:exercise_name,
      language_name:language_name
    }
    assert status?(200), status
    assert json_content?, content_type
    assert_equal [path], json_response.keys.sort, :keys
    id = json_response[path] # eg H3Nqu2
    assert kata_exists?(id), "id:#{id}:"
    manifest = kata_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  private

  def group_exists?(id)
    dirname = group_id_path(id)
    command = saver.dir_exists_command(dirname)
    saver.run(command)
  end

  def kata_exists?(id)
    dirname = kata_id_path(id)
    command = saver.dir_exists_command(dirname)
    saver.run(command)
  end

  include IdPather

  # - - - - - - - - - - - - - - - - - - - -

  def group_manifest(id)
    filename = "#{group_id_path(id)}/manifest.json"
    command = saver.file_read_command(filename)
    JSON::parse!(saver.run(command))
  end

  def kata_manifest(id)
    filename = "#{kata_id_path(id)}/manifest.json"
    command = saver.file_read_command(filename)
    JSON::parse!(saver.run(command))
  end

  # - - - - - - - - - - - - - - - - - - - -

  def saver
    ExternalSaver.new(http)
  end

  def http
    ExternalHttp.new
  end

  # - - - - - - - - - - - - - - - - - - - -

  def json_post(path, data)
    post '/'+path, data.to_json, JSON_REQUEST_HEADERS
  end

  # - - - - - - - - - - - - - - - - - - - -

  def json_response
    @json_response ||= JSON.parse(last_response.body)
  end

end
