# frozen_string_literal: true
require_relative 'test_base'
require 'ostruct'

class ReadyTest < TestBase

  def self.id58_prefix
    'a86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15D',
  %w( ready when languages-start-points and creator are both ready ) do
    get '/ready'
    assert last_response.ok?
    assert_equal '{"ready?":true}', last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  test '15E',
  %w( not ready when creator is not ready ) do
    @externals = ExternalsReadyStub.new(false,true)
    get '/ready'
    assert last_response.ok?
    assert_equal '{"ready?":false}', last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  test '15F',
  %w( not ready when languages-start-points is not ready ) do
    @externals = ExternalsReadyStub.new(true,false)
    get '/ready'
    assert last_response.ok?
    assert_equal '{"ready?":false}', last_response.body
  end

  private

  class ExternalsReadyStub
    def initialize(creator_ready, languages_ready)
      @creator_ready = creator_ready
      @languages_ready = languages_ready
    end
    def creator
      OpenStruct.new(ready?:@creator_ready)
    end
    def languages_start_points
      OpenStruct.new(ready?:@languages_ready)
    end
  end

end
