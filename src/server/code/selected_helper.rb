# frozen_string_literal: true
module SelectedHelper

  def selected(visible_files)
    filenames = visible_files.keys.sort
    find_filename(filenames, 'test')      ||
      find_filename(filenames, 'feature') ||
        find_filename(filenames, 'spec')    ||
          find_content(visible_files, 'assert') ||
            find_content(visible_files, 'answer') ||
              filenames[0]
  end

  def find_filename(filenames, word)
    filenames.find{ |filename| filename.downcase.include?(word) }
  end

  def find_content(visible_files, word)
    s = visible_files.find{ |filename,file| file['content'].include?(word) }
    s ? s[0] : nil
  end

end
