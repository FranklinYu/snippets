require 'forwardable'
require_relative 'basic_error'

class Disc
  class ConflictingError < ErrorBase::ConflictingError
    # @!attribute [r] this
    #   @return [Disc] this disc.
    # @!attribute [r] other
    #   @return [Disc] the other disc conflicting with this disc.

    # @param this [Disc] this disc
    # @param other [Disc] the other disc conflicting with this disc
    def initialize(this, other)
      super(this, other, 'album')
    end
  end

  # @param [Object] track_count total number of tracks in this disc.
  # @param [Object] album the album this disc belongs to.
  def initialize(track_count, album)
    # Type: Album
    # the album this disc is affiliated to.
    @album = album
    @tracks = Array.new(track_count)
  end

  # @return [Integer] the total number of tracks.
  def track_count
    @tracks.size
  end

  # @param i [Integer] the index, starting at 0
  # @return [Track] the +i+th track, or nil if it does not exist
  def [](i)
    @tracks[i]
  end

  # @param i [Integer] the index
  # @param track [Track] the track to add, or nil if it does not exist
  # @return [Track] +track+
  def []=(i, track)
    @tracks[i] = track
  end

  include Enumerable
  extend Forwardable
  def_delegators :@tracks, :each, :each_index
end
