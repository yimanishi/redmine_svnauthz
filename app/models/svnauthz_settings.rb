class SvnauthzSettings < ActiveRecord::Base
  unloadable

  validates_presence_of :directory
  validates_uniqueness_of :directory
  validates_length_of :directory, :maximum => 255
  validates_length_of :permission, :maximum => 255
end
