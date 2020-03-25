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
  |Rule 1:
  |when there are filenames
  |which include the word 'test'
  |then select the one with the largest content
  ) do
    expected = 'HikerTest.java' # eg java-approval
    assert_equal expected, selected(make_visible_files([
      [ expected                       , 'import org.junit.*;...'    ],
      [ 'HikerTest.hhgttg.approved.txt', '42'                        ]
    ]))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '842', %w(
  |Rule 2:
  |when then are filenames
  |which include the word 'feature'
  |then select the one with the largest content
  ) do
    expected = 'hiker.feature' # eg gplusplus-cucumber
    assert_equal expected, selected(make_visible_files([
      [ expected         , 'x'*23 ],
      [ 'smaller.feature', 'y'*22 ]
    ]))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '843', %w(
  |Rule 3:
  |when there are filenames
  |which include the word 'spec'
  |then select the one with the largest content
  ) do
    expected = 'hiker_spec.rb' # eg ruby-approval
    assert_equal expected, selected(make_visible_files([
      [ expected      , 'x'*23 ],
      [ 'smaller.spec', 'y'*22 ]
    ]))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '844', %w(
  |Rule 4:
  |when there is no filename
  |which includes the word 'test' or 'feature' or 'spec'
  |then select filename whose content includes the word 'assert'.
  ) do
    expected = 'src/lib.rs' # eg rust-test
    assert_equal expected, selected(make_visible_files([
      [ expected   , 'assert_eq!(42, answer());' ],
      [ 'other.txt', 'your task is to....'       ]
    ]))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '845', %w(
  |Rule 5:
  |when there is no file
  |which includes the word 'test' or 'feature' or 'spec'
  |then select the filename whose content includes the word 'answer'.
  ) do
    expected = 'hiker.pl' # eg prolog-plunit
    assert_equal expected, selected(make_visible_files([
        [ expected   , 'answer(X) :- X is 6 * 9.' ],
        [ 'other.txt', 'your task is to....'      ]
    ]))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '846', %w(
  |Rule 6:
  |when language-start-points-all gets a new entry
  |and it misses all the above cases
  |then select the first filename alphabetically (often cyber-dojo.sh)
  ) do
    expected = 'cyber-dojo.sh'
    assert_equal expected, selected(make_visible_files([
      [ expected  , 'blah blah'           ],
      [ 'data.txt', '...data.txt content' ],
      [ 'makefile', '....'                ]
    ]))
  end

  # - - - - - - - - - - - - - - - - - - -

  test '847', %w(
  |Rule7:
  |these rules cover all current languages-start-points manifests
  ) do
    manifests.each do |display_name,manifest|
      refute_nil selected(manifest['visible_files']), display_name
    end
  end

  private

  def make_visible_files(data)
    visible_files = {}
    data.each do |filename,content|
      visible_files[filename] = { 'content' => content }
    end
    visible_files
  end

end
