require_dependency 'custom_field'

module ExtendedCustomFieldPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
    end

    module InstanceMethods

        def possible_values
            case self.field_format
            when 'project':
                projects = Project.all(:conditions => Project.visible_by(User.current), :order => 'name') # FIXME: what if user edit?
                projects.collect{ |project| [ project.name, project.id.to_s ] }
            else
                read_attribute(:possible_values)
            end
        end

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
