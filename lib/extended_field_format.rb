module Redmine
    module FieldFormat

        class ProjectFormat < RecordList
            add 'project'
            self.form_partial = 'custom_fields/formats/project'

            def cast_single_value(custom_field, value, customized = nil)
                unless value.blank?
                    Project.find_by_id(value)
                else
                    nil
                end
            end

            def possible_values_options(custom_field, object = nil)
                if object.is_a?(User)
                    projects = Project.visible(object).all
                else
                    projects = Project.visible.all
                end
                projects.collect{ |project| [ project.name, project.id.to_s ] }
            end

            # TODO instead of ExtendedFieldsHelperPatch
            #def formatted_value(view, custom_field, value, customized = nil, html = false)
            #    if html
            #    else
            #    end
            #end

            # TODO instead of ExtendedFieldsHelperPatch
            #def edit_tag(view, tag_id, tag_name, custom_value, options = {})
            #end

            # TODO ?
            #def bulk_edit_tag(view, tag_id, tag_name, custom_field, objects, value, options = {})
            #end
        end

    end
end
