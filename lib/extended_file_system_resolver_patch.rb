module ExtendedFileSystemResolverPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
    end

    module InstanceMethods

        def [](template)
            if File.exist?(File.join(@path, "#{template}.erb"))
                true
            else
                false
            end
        end

    end

end
