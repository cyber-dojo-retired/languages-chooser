# frozen_string_literal: true
require_relative 'test_base'

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
    _stdout,stderr = capture_stdout_stderr {
      get '/'+path, {
        exercise_name:'unknown',
        language_name:language_name
      }
    }
    # puts _stdout
    # puts '~~~~~~~~~'
    assert_equal '', stderr
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'Je5', %w(
  |GET/group_create with unknown exercise_name
  |is 500 error
  ) do
    path = 'kata_create'
    _stdout,stderr = capture_stdout_stderr {
      get '/'+path, {
        exercise_name:'unknown',
        language_name:language_name
      }
    }
    # puts _stdout
    # puts '~~~~~~~~~'
    assert_equal '', stderr    
    assert status?(500), status
  end

end
