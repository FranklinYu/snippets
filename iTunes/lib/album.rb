require_relative 'basic_error'
require 'forwardable'

class Album
  class ConflictingError < ErrorBase::ConflictingError
    # @!attribute [r] this
    #   @return [Album] this album.
    # @!attribute [r] other
    #   @return [Album] the other album conflicting with this album.

    # @param this [Album] this album
    # @param other [Album] the other album conflicting with this album
    def initialize(this, other)
      super(this, other, 'album')
    end
  end

  # @return [String] the name of the artist.
  attr_reader :artist
  # @return [String] the name of the album.
  attr_reader :name
  # @return [Integer] the year of the album.
  attr_reader :year

  # @param artist [String] the name of the artist
  # @param name [String] the name of the album
  # @param year [Integer] the year of the album
  # @param disc_count [Integer] the total number of disks
  # @raise [ArgumentError] if any parameter is +nil+.
  def initialize(artist, name, year, disc_count)
    {artist: artist, name: name, year: year, disc_count: disc_count}.each do |key, value|
      raise ArgumentError, "parameter #{key} should not be nil" if value.nil?
    end
    @artist = artist
    @name = name
    @year = year
    # @type [Array<Disc>]
    @discs = Array.new(disc_count)
  end

  # @return [Integer] the total number of disks.
  def disc_count
    @discs.size
  end

  def hash
    @artist.hash ^ @name.hash ^ @year.hash
  end

  # Compare this Album with +other+.
  #
  # @param other [Album] the other album
  # @return [Boolean] whether this Album is the same as +other+.
  # @raise [ConflictingError] if this album and the other one should be the same album, but some data does not match.
  def ==(other)
    if @artist == other.artist and @name == other.name and @year == other.year
      raise ConflictingError.new(self, other) if disc_count != other.disc_count
      true
    else
      false
    end
  end
  alias eql? ==

  # @param i [Integer] the index, starting at 0
  # @return [Track] the +i+th disc, or nil if it does not exist
  def [](i)
    @discs[i]
  end

  # @param i [Integer] the index
  # @param disc [Disc] the disc to add
  # @return [Disc] +disc+, or nil if it does not exist
  def []=(i, disc)
    @discs[i] = disc
  end

  # Return the +i+th disc if it exist, or create a disc with +track_count+ number of tracks.
  #
  # @param i [Integer] the index, starting at 0
  # @param track_count [Integer] total number of tracks in said disc
  # @return [Disc] +disc+
  def disc(i, track_count:)
    raise "track number #{i}/#{track_count} invalid" if i >= track_count
    if @discs[i].nil?
      @discs[i] = Disc.new(track_count, self)
    end
    @discs[i]
  end

  include Enumerable
  extend Forwardable
  def_delegators :@discs, :each, :each_index
end
