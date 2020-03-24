# frozen_string_literal: true
require_relative 'test_base'
require_src 'selected_helper'

class LargestTest < TestBase

  def self.id58_prefix
    '5FF'
  end

  include SelectedHelper

  # - - - - - - - - - - - - - - - - - - -

  test '841', %w(
  Rule 1:
  when there is a filename
  which includes the word 'test'
  then select it
  ) do
    expected = 'HikerTest.java' # eg java-junit
    assert_equal expected, selected(make_visible_files(expected))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '842', %w(
  Rule 2:
  when there is a filename
  which includes the word 'feature'
  then select it
  ) do
    expected = 'hiker.feature' # eg gplusplus-cucumber
    assert_equal expected, selected(make_visible_files(expected))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '843', %w(
  Rule 3:
  when there is a filename
  which includes the word 'spec'
  then select it
  ) do
    expected = 'hiker_spec.rb' # eg ruby-approval
    assert_equal expected, selected(make_visible_files(expected))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '844', %w(
  Rule 4:
  when there is no filename
  which includes the word 'test' or 'feature' or 'spec'
  then select filename whose content includes the word 'assert'.
  ) do
    expected = 'src/lib.rs' # eg rust-test
    content = 'assert_eq!(42, answer());'
    assert_equal expected, selected(make_visible_files(expected,content))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '845', %w(
  Rule 5:
  when there is no file
  which includes the word 'test' or 'feature' or 'spec'
  then select the filename whose content includes the word 'answer'.
  ) do
    expected = 'hiker.pl' # eg prolog-plunit
    content = 'answer(X) :- X is 6 * 9.'
    assert_equal expected, selected(make_visible_files(expected,content))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '846', %w(
  Rule 6:
  when language-start-points-all gets a new entry
  and it misses all the above cases
  then select the first filename alphabetically (often cyber-dojo.sh)
  ) do
    expected = 'cyber-dojo.sh'
    assert_equal expected, selected(make_visible_files(expected))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '847', %w(
  these rules cover all current languages-start-points manifests
  ) do
    manifests.each do |display_name,manifest|
      refute_nil selected(manifest['visible_files']), display_name
    end
  end

  private

  def make_visible_files(filename, content='y*42')
    {
      'readme.txt' => { 'content' => 'a'*23 },
      filename => { 'content' => content }
    }
  end

end
