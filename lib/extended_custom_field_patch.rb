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

        def template_file
            if instance_variable_defined?(:@template)
                @template
            else
                filename = name.gsub(%r{[^a-z0-9_]+}i, '_').downcase
                template = File.join(File.dirname(__FILE__), '../app/views/custom_values', field_format, "_#{filename}.rhtml")
                if File.exists?(template)
                    @template = "custom_values/#{field_format}/#{filename}"
                else
                    template = File.join(File.dirname(__FILE__), '../app/views/custom_values/common', "_#{field_format}.rhtml")
                    if File.exists?(template)
                        @template = "custom_values/common/#{field_format}"
                    else
                        @template = nil
                    end
                end
            end
        end

        def has_template?
            !!template_file
        end

    end

end
