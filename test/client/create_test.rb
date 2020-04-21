# frozen_string_literal: true
require_relative 'id_pather'
require_relative 'test_base'
require_src 'external_http'
require_src 'external_saver'
require 'json'

class CreateTest < TestBase

  def self.id58_prefix
    'xRa'
  end

  def exercise_name
    'Fizz Buzz'
  end

  def language_name
    'Java, JUnit'
  end

  # - - - - - - - - - - - - - - - - -

  test 'e5D', %w(
  |PATH /languages-chooser/group_choose
  |shows languages display-names
  |selecting one
  |clicking [ok] button
  |redirects to /kata/group/:ID
  ) do
    visit("/languages-chooser/group_choose?exercise_name=#{exercise_name}")
    find('div.display-name', text:language_name).click
    find('button#ok').click
    assert %r"/kata/group/(?<id>.*)" =~ current_path, current_path
    assert group_exists?(id), "id:#{id}:"
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'e5E', %w(
  |PATH /languages-chooser/kata_choose
  |shows languages display-names
  |selecting one
  |clicking [ok] button
  |redirects to /kata/edit/:ID
  ) do
    visit("/languages-chooser/kata_choose?exercise_name=#{exercise_name}")
    find('div.display-name', text:language_name).click
    find('button#ok').click
    assert %r"/kata/edit/(?<id>.*)" =~ current_path, current_path
    assert kata_exists?(id), "id:#{id}:"
    manifest = kata_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test '4C8', %w(
    |PATH /languages-chooser/group_choose
    |shows languages display-names
    |one is already selected at random
    |so clicking [ok] button
    |redirects to /kata/group/:ID
  ) do
    visit("/languages-chooser/group_choose?exercise_name=#{exercise_name}")
    find('button#ok').click
    assert %r"/kata/group/(?<id>.*)" =~ current_path, current_path
    assert group_exists?(id), "id:#{id}:"
    manifest = group_manifest(id)
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test '4C9', %w(
    |PATH /languages-chooser/kata_choose
    |shows languages display-names
    |one is already selected at random
    |so clicking [ok] button
    |redirects to /kata/edit/:ID
  ) do
    visit("/languages-chooser/kata_choose?exercise_name=#{exercise_name}")
    find('button#ok').click
    assert %r"/kata/edit/(?<id>.*)" =~ current_path, current_path
    assert kata_exists?(id), "id:#{id}:"
    manifest = kata_manifest(id)
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  private

  include IdPather

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
    ExternalSaver.new(saver_http)
  end

  def saver_http
    ExternalHttp.new
  end

end
