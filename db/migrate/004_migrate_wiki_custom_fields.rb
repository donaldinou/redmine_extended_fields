class MigrateWikiCustomFields < ActiveRecord::Migration

    def self.up
        if CustomField.column_names.include?('format_store')
            say " ***> MigrateWikiCustomFields.up:"
            CustomField.connection.select_rows("SELECT id FROM custom_fields WHERE field_format = 'wiki'").each do |id|
                say " ***> #{id}"
                if custom_field = CustomField.find_by_id(id)
                    say " ***> #{custom_field.inspect}"
                    #custom_field.update_attribute(:field_format, 'wiki') # FIXME update_attributes?
                end
            end
            raise ActiveRecord::RecordNotFound
        end
    end

end
