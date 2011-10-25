require_dependency 'custom_field'

module ExtendedCustomFieldPatch # TODO: try without patching

    EXTENDED_FIELD_FORMATS = %w(wiki link project)

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
                template = File.join(File.dirname(__FILE__), '../app/views/custom_values', field_format, "#{filename}.rhtml")
                if File.exists?(template)
                    @template = template
                else
                    template = File.join(File.dirname(__FILE__), '../app/views/custom_values', field_format, "#{filename}.html.erb")
                    if File.exists?(template)
                        @template = template
                    else
                        @template = nil
                    end
                end
            end
        end

        def extended? # TODO
            Rails.logger.info " >>> #{template_file.inspect}" # FIXME
            EXTENDED_FIELD_FORMATS.include?(field_format) || template_file
        end

    end

end
