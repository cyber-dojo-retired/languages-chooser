# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'capture_stdout_stderr'
require_src 'app'
require_src 'externals'

class TestBase < Id58TestBase
  include CaptureStdoutStderr
  include Rack::Test::Methods # [1]

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def app
    App.new(externals) # [1]
  end

  def languages_names
    manifests.keys.sort
  end

  def manifests
    languages_start_points.manifests
  end

  def languages_start_points
    externals.languages_start_points
  end

  # - - - - - - - - - - - - - - -

  JSON_CONTENT = 'application/json'

  JSON_REQUEST_HEADERS = {
    'CONTENT_TYPE' => JSON_CONTENT, # request sent by client
    'HTTP_ACCEPT'  => JSON_CONTENT  # response received by client
  }

  # - - - - - - - - - - - - - - -

  def status?(expected)
    status === expected
  end

  def status
    last_response.status
  end

  # - - - - - - - - - - - - - - -

  def html_content?
    content_type === 'text/html;charset=utf-8'
  end

  def json_content?
    content_type === JSON_CONTENT
  end

  def css_content?
    content_type === 'text/css; charset=utf-8'
  end

  def content_type
    last_response.headers['Content-Type']
  end

  # - - - - - - - - - - - - - - -

  def escape_html(text)
    Rack::Utils.escape_html(text)
  end

  # - - - - - - - - - - - - - - -

  def verify_exception_info_on(stdout, name)
    json = JSON.parse!(stdout)
    assert_equal ['exception'], json.keys, stdout
    ex = json['exception']
    assert_equal ['request','backtrace',name].sort, ex.keys.sort, stdout
  end

end
