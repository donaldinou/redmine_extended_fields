require 'redmine'
require 'dispatcher'

require_dependency 'extended_fields_hook'

# TODO: + Hint to custom fields form + inline hint
# TODO: support CSS class?

# TODO:
#  o CustomField#cast_value
#  o CustomField#order_statement
#  o Query#add_custom_fields_filters
#  o CustomFieldsHelper:custom_field_tag
#  o CustomFieldsHelper:custom_field_tag_for_bulk_edit

RAILS_DEFAULT_LOGGER.info 'Starting Extended Fields plugin for Redmine'

Redmine::CustomFieldFormat.map do |fields|
    fields.register    WikiCustomFieldFormat.new('wiki',    :label => :label_wiki_text, :order => 2.1)
    fields.register    LinkCustomFieldFormat.new('link',    :label => :label_link,      :order => 2.2)
    fields.register ProjectCustomFieldFormat.new('project', :label => :label_project,   :order => 8)
end

Dispatcher.to_prepare :extended_fields_plugin do
    unless CustomField.included_modules.include?(ExtendedCustomFieldPatch)
        CustomField.send(:include, ExtendedCustomFieldPatch)
    end
    unless CustomFieldsHelper.included_modules.include?(ExtendedFieldsHelperPatch)
        CustomFieldsHelper.send(:include, ExtendedFieldsHelperPatch)
    end
end

Redmine::Plugin.register :extended_fields_plugin do
    name 'Extended fields'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com'
    description 'Adds new custom field types which can be used in user profile.'
    version '1.0.0'
end
