# TODO: add :is_for_new and :hint

class MigrateExtendedProfile < ActiveRecord::Migration # PROFILE

    def self.up
        position = UserCustomField.maximum(:position) || 0

        UserCustomField.create(:name => 'Company',             :field_format => 'string',  :position => position += 1, :searchable => true)
        UserCustomField.create(:name => 'Company website',     :field_format => 'link',    :position => position += 1)
        UserCustomField.create(:name => 'Position',            :field_format => 'string',  :position => position += 1, :searchable => true)
        UserCustomField.create(:name => 'Project of interest', :field_format => 'project', :position => position += 1, :searchable => true, :visible => false)
        UserCustomField.create(:name => 'Personal website',    :field_format => 'link',    :position => position += 1)
        UserCustomField.create(:name => 'Blog',                :field_format => 'link',    :position => position += 1)
        UserCustomField.create(:name => 'Facebook',            :field_format => 'string',  :position => position += 1, :regexp => '^([0-9]+|[A-Za-z0-9.]+)$')
        UserCustomField.create(:name => 'Twitter',             :field_format => 'string',  :position => position += 1, :regexp => '^[A-Za-z0-9_]+$')
        UserCustomField.create(:name => 'LinkedIn',            :field_format => 'link',    :position => position += 1)

        # TODO: migrate data
    end

end
