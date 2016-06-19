module ErrorBase
  # @!visibility private
  class ConflictingError < RuntimeError
    # @return [Object] this object.
    attr_reader :this
    # @return [Object] the other object conflicting with this object.
    attr_reader :other

    # @param this [Object] this object
    # @param other [Object] the other object conflicting with this object
    # @param name [String] the name of the class of +this+ and +other+
    def initialize(this, other, name = 'object')
      @this = this
      @other = other
      super("Conflicting #{name}.")
    end
  end
end
