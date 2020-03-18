# frozen_string_literal: true

class Chooser

  def initialize(externals)
    @externals = externals
  end

  def alive?
    true
  end

  def ready?
    [creator,languages_start_points].all?(&:ready?)
  end

  def sha
    ENV['SHA']
  end

  def manifests
    languages_start_points.manifests
  end

  def group_create(display_names:)
    creator.group_create(display_names)
  end

  def kata_create(display_name:)
    creator.kata_create(display_name)
  end

  private

  def creator
    @externals.creator
  end

  def languages_start_points
    @externals.languages_start_points
  end

end
