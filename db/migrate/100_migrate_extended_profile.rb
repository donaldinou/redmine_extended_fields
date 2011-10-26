class MigrateExtendedProfile < ActiveRecord::Migration

    def self.up
        position = 0
        UserCustomField.create(:name => 'Company', :field_format => 'string', :position => position += 1, :searchable => true)
    end

end
