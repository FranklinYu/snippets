require 'nokogiri'
require 'plist'
require 'set'
require_relative 'lib/basic_error'
require_relative 'lib/album'
require_relative 'lib/disc'

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

class Array
  # Ensure that an object is included in this array.
  #
  # @param [Object] e the object that should be in this array.
  # @return [Object] +e+ or its equivalence in this collection
  def ensure(e)
    i = self.index e
    if i.nil?
      self << e
      e
    else
      self[i]
    end
  end
end

plist = Plist::parse_xml(ARGF)

REQUIRED_PROPERTIES = [
    'Name', 'Album Artist', 'Album', 'Year', 'Disc Count', 'Disc Number', 'Track Count', 'Track Number'
]
albums = []
plist['Tracks'].each_value do |track_info|
  missing_property = REQUIRED_PROPERTIES.detect { |key| track_info[key].nil? }
  unless missing_property.nil?
    $stderr.puts "Property <#{missing_property}> is missing. Track information dumped below:"
    $stderr.puts track_info
    $stderr.puts 'This track is skipped.'
    next
  end
  track_info['Artist'] ||= track_info['Album Artist']
  album = Album.new(track_info['Artist'], track_info['Album'], track_info['Year'], track_info['Disc Count'])
  begin
    album = albums.ensure album
  rescue ErrorBase::ConflictingError => e
    $stderr.puts e.to_s
    $stderr.puts e.this, e.other
    exit false
  end
  track = Track.new track_info['Name'], track_info['Artist']
  album.disc(track_info['Disc Number'] - 1, track_count: track_info['Track Count'])[track_info['Track Count']] = track
end

root_xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
  xml.albums {
    albums.each do |album|
      xml.album {
        xml.name album.name
        xml.artist album.artist
        xml.year album.year
        xml.disc_count album.disc_count
        album.each do |disc|
          if disc.nil?
            xml.disc
          else
            xml.disc {
              disc.each_index do |i|
                track = disc[i]
                xml.track {
                  xml.track_number i
                  xml.name track.name
                  xml.artist track.artist
                } unless track.nil?
              end
            }
          end
        end
      }
    end
  }
end

puts root_xml.to_xml
