# frozen_string_literal: true
module SelectedHelper

  def selected(visible_files)
    filenames = visible_files.keys.sort
    find_filename(visible_files, 'test') ||
      find_filename(visible_files, 'feature') ||
        find_filename(visible_files, 'spec') ||
          find_content(visible_files, 'assert') ||
            find_content(visible_files, 'answer') ||
              filenames[0]
  end

  def find_filename(visible_files, word)
    filenames = visible_files.keys.select { |filename|
      filename.downcase.include?(word)
    }
    sizeof = lambda { |filename|
      visible_files[filename]['content'].size
    }
    filenames.max { |lhs,rhs|
      sizeof.call(lhs) <=> sizeof.call(rhs)
    }
  end

  def find_content(visible_files, word)
    s = visible_files.find{ |filename,file| file['content'].include?(word) }
    s ? s[0] : nil
  end

end
