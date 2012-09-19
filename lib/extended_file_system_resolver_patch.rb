module ExtendedFileSystemResolverPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
    end

    module InstanceMethods

        def [](template)
            # TODO
        end

    end

end
