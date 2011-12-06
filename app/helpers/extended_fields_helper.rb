module ExtendedFieldsHelper

    def find_custom_field_template(custom_field)
        filename = custom_field.name.gsub(%r{[^a-z0-9_]+}i, '_').downcase
        filename.gsub!(%r{(^_+|_+$)}, '')

        unless filename.empty?
            self.view_paths.each do |load_path|
                if template = load_path["custom_values/#{custom_field.field_format}/_#{filename}"]
                    return "custom_values/#{custom_field.field_format}/#{filename}"
                end
            end

            self.view_paths.each do |load_path|
                if template = load_path["custom_values/common/_#{custom_field.field_format}"]
                    return "custom_values/common/#{custom_field.field_format}"
                end
            end
        end

        nil
    end

end
