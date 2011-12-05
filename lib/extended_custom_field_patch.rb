require_dependency 'custom_field'

module ExtendedCustomFieldPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            if defined? possible_values_options
                alias_method_chain :possible_values_options, :extended
            end
        end
    end

    module InstanceMethods

        if defined? possible_values_options

            def possible_values_options_with_extended(obj = nil)
                case field_format
                when 'project'
                    if obj.is_a?(User)
                        projects = Project.visible(obj).all
                    else
                        projects = Project.visible.all
                    end
                    projects.collect{ |project| [ project.name, project.id.to_s ] }
                else
                    possible_values_options_without_extended(obj)
                end
            end

        else

            def possible_values(dummy = nil)
                case field_format
                when 'project'
                    Project.visible.all.collect{ |project| [ project.name, project.id.to_s ] }
                else
                    read_attribute(:possible_values)
                end
            end

            alias_method :possible_values_options, :possible_values

        end

    end

end
