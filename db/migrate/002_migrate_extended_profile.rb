class MigrateExtendedProfile < ActiveRecord::Migration # PROFILE

    def self.up
        pos = UserCustomField.maximum(:position) || 0
        settings = Setting.respond_to?(:plugin_extended_profile_plugin) ? Setting.plugin_extended_profile_plugin : nil

        company      = UserCustomField.create(:name => 'Company',             :field_format => 'string',  :position => pos += 1, :is_for_new => false, :searchable => true)
        company_site = UserCustomField.create(:name => 'Company website',     :field_format => 'link',    :position => pos += 1, :is_for_new => false)
        position     = UserCustomField.create(:name => 'Position',            :field_format => 'string',  :position => pos += 1, :is_for_new => false, :searchable => true)
        project      = UserCustomField.create(:name => 'Project of interest', :field_format => 'project', :position => pos += 1, :visible    => false, :searchable => true, :is_required => (settings && settings[:require_project]) ? true : false)
        website      = UserCustomField.create(:name => 'Personal website',    :field_format => 'link',    :position => pos += 1, :is_for_new => false)
        blog         = UserCustomField.create(:name => 'Blog',                :field_format => 'link',    :position => pos += 1, :is_for_new => false)
        facebook     = UserCustomField.create(:name => 'Facebook',            :field_format => 'string',  :position => pos += 1, :is_for_new => false, :regexp => '^([0-9]+|[A-Za-z0-9.]+)$', :hint => 'e.g. 100000066953233 or andriy.lesyuk')
        twitter      = UserCustomField.create(:name => 'Twitter',             :field_format => 'string',  :position => pos += 1, :is_for_new => false, :regexp => '^@?[A-Za-z0-9_]+$',        :hint => 'e.g. AndriyLesyuk')
        linkedin     = UserCustomField.create(:name => 'LinkedIn',            :field_format => 'link',    :position => pos += 1, :is_for_new => false)

        User.find(:all).each do |user|
            CustomValue.create(:custom_field => company,      :customized => user, :value => user.profile[:company])       if user.profile[:company].present?
            CustomValue.create(:custom_field => company_site, :customized => user, :value => user.profile[:company_site])  if user.profile[:company_site].present?
            CustomValue.create(:custom_field => position,     :customized => user, :value => user.profile[:position])      if user.profile[:position].present?
            CustomValue.create(:custom_field => project,      :customized => user, :value => user.profile[:project_id])    if user.profile[:project_id].present?
            CustomValue.create(:custom_field => website,      :customized => user, :value => user.profile[:personal_site]) if user.profile[:personal_site].present?
            CustomValue.create(:custom_field => blog,         :customized => user, :value => user.profile[:blog])          if user.profile[:blog].present?
            CustomValue.create(:custom_field => facebook,     :customized => user, :value => user.profile[:facebook])      if user.profile[:facebook].present?
            CustomValue.create(:custom_field => twitter,      :customized => user, :value => user.profile[:twitter])       if user.profile[:twitter].present?
            CustomValue.create(:custom_field => linkedin,     :customized => user, :value => user.profile[:linkedin])      if user.profile[:linkedin].present?
        end
    end

end
