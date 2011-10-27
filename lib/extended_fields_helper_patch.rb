# FIXME: issue: export_to_cvs should be using format_value

require_dependency 'custom_fields_helper'

module ExtendedFieldsHelperPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method :show_value, :show_extended_value
            alias_method_chain :custom_field_tag, :extended
        end
    end

    module InstanceMethods

        def show_extended_value(custom_value)
            if custom_value
                if custom_value.custom_field.has_template?
                    ActiveSupport::SafeBuffer.new(render(:partial => custom_value.custom_field.template_file,
                                                         :locals  => { :controller   => controller,
                                                                       :project      => @project,
                                                                       :request      => request,
                                                                       :custom_field => custom_value }))
                else
                    Redmine::CustomFieldFormat.format_value(custom_value.value, custom_value.custom_field.field_format)
                end
            end
        end

        def custom_field_tag_with_extended(name, custom_value)
            custom_field = custom_value.custom_field
            field_title  = custom_field.name.gsub(%r{[^a-z0-9_]+}i, '_').downcase

            unless field_title.blank?
                field_name   = "#{name}[custom_field_values][#{custom_field.id}]"
                field_id     = "#{name}_custom_field_values_#{custom_field.id}"
                field_class  = "#{name}_custom_field_values_#{field_title}"
                field_format = Redmine::CustomFieldFormat.find_by_name(custom_field.field_format)

                case field_format.try(:edit_as)
                when 'string', 'link'
                    tag = text_field_tag(field_name, custom_value.value, :id => field_id, :class => field_class)
                else
                    tag = custom_field_tag_without_extended(name, custom_value)
                end
            else
                tag = custom_field_tag_without_extended(name, custom_value)
            end

            unless custom_field.hint.blank?
                tag << '<br />'
                tag << content_tag(:em, custom_field.hint)
            end

            tag
        end

    end

end
