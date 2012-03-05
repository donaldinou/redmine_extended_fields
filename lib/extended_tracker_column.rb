class ExtendedTrackerColumn < ExtendedColumn

    def initialize(name, options = {})
        super
        @tracker = options[:tracker] if options[:tracker]
    end

    def value(project)
        # TODO
        0
    end

end
