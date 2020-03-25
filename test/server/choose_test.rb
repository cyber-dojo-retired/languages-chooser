# frozen_string_literal: true
require_relative 'test_base'

class ChooseTest < TestBase

  def self.id58_prefix
    'a73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |given the languages-start-points service is ready
  |when I request GET/group_choose
  |then the resulting page offers the names of all languages-start-points
  |ready for me to select one and create a group-exercise
  ) do
    get '/group_choose'
    assert status?(200), status
    html = last_response.body
    assert heading(html).include?('our'), html
    refute heading(html).include?('my'), html
    languages_names.each do |language_name|
      assert html =~ div_for(language_name), language_name
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '19w', %w(
  |given the languages-start-points service is ready
  |when I request GET/kata_choose
  |then the resulting page offers the names of all languages-start-points
  |ready for me to select one and create an individual exercise
  ) do
    get '/kata_choose'
    assert status?(200), status
    html = last_response.body
    assert heading(html).include?('my'), html
    refute heading(html).include?('our'), html
    languages_names.each do |language_name|
      assert html =~ div_for(language_name), language_name
    end
  end

  private

  def heading(html)
    # (.*?) for non-greedy match
    # /m for . matching newlines
    html.match(/<div id="heading">(.*?)<\/div>/m)[1]
  end

  def div_for(display_name)
    # eg cater for "C++ (clang++), GoogleMock"
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
