class ExtendedColumn
    include Redmine::I18n

    attr_accessor :name, :caption, :align

    def initialize(name, options={})
        self.name = name
        self.caption = l(options[:caption] || "field_#{name}")
        self.align = options[:align] if options[:align]

        @css_classes = options[:css_classes] if options[:css_classes]
    end

    # TODO: default_order

    def css_classes
        @css_classes || name
    end

    def value(object)
        if object.respond_to?(name)
            object.send(name)
        end
    end

end
