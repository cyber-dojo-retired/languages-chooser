# frozen_string_literal: true
require_relative 'test_base'
require 'json'

class RequestErrorTest < TestBase

  def self.id58_prefix
    'q7D'
  end

  def id58_setup
    @exercise_name = 'Fizz Buzz'
    @language_name = languages_names.sample
  end

  attr_reader :exercise_name, :language_name

  # - - - - - - - - - - - - - - - - -

  test 'Je4', %w(
  |GET/kata_create with unknown exercise_name
  |is 500 error
  ) do
    path = 'kata_create'
    stdout,stderr = capture_stdout_stderr {
      get '/'+path, {
        exercise_name:'unknown',
        language_name:language_name
      }
    }
    verify_exception_info_on(stdout, 'http_service')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'Je5', %w(
  |GET/group_create with unknown exercise_name
  |is 500 error
  ) do
    path = 'kata_create'
    stdout,stderr = capture_stdout_stderr {
      get '/'+path, {
        exercise_name:'unknown',
        language_name:language_name
      }
    }
    verify_exception_info_on(stdout, 'http_service')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'Bq6', %w(
  |GET/group_create with unknown parameter
  |is 500 error
  ) do
    path = 'kata_create'
    stdout,stderr = capture_stdout_stderr {
      get '/'+path, {
        not_exercise_name:exercise_name,
        language_name:language_name
      }
    }
    verify_exception_info_on(stdout, 'message')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'Bq7', %w(
  |GET/group_create with extra parameter
  |is 500 error
  ) do
    path = 'kata_create'
    stdout,stderr = capture_stdout_stderr {
      get '/'+path, {
        exercise_name:exercise_name,
        language_name:language_name,
        extra:'wibble'
      }
    }
    verify_exception_info_on(stdout, 'message')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end

end
