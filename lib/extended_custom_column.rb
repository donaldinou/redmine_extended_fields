class ExtendedCustomColumn < ExtendedColumn
    
    def initialize(name, caption, options = {})
        super(name, options.merge(:caption => caption))
    end

    def caption
        @caption
    end
end
