require_dependency 'custom_field'

module ExtendedCustomFieldPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method_chain :possible_values_options, :extended
        end
    end

    module InstanceMethods

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

        #def possible_values_with_extended(obj = nil) # FIXME: for Redmine 1.1.x?
        #    case self.field_format
        #    when 'project':
        #        # FIXME: what if user edit?
        #        Project.visible.all.collect{ |project| [ project.name, project.id.to_s ] }
        #    else
        #        possible_values_without_extended(obj)
        #    end
        #end

    end

end
