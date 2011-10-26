# FIXME: issue: export_to_cvs should be using format_value

require_dependency 'custom_fields_helper'

module ExtendedFieldsHelperPatch

    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method :show_value, :show_extended_value
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

    end

end
