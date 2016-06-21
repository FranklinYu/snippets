class Track
  # @return [String] name of this track.
  attr_reader :name
  # @return [String] artist of this track (may be different from album artist).
  attr_reader :artist

  # @param name [String] name of this track.
  # @param artist [String] artist of this track (may be different from album artist).
  def initialize(name, artist)
    @name = name
    @artist = artist
  end
end
