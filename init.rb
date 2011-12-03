require 'redmine'
require 'dispatcher'

require_dependency 'extended_fields_hook'

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
    unless CustomValue.included_modules.include?(ExtendedCustomValuePatch)
        CustomValue.send(:include, ExtendedCustomValuePatch)
    end
    unless Query.included_modules.include?(ExtendedCustomQueryPatch)
        Query.send(:include, ExtendedCustomQueryPatch)
    end
    unless CustomFieldsHelper.included_modules.include?(ExtendedFieldsHelperPatch)
        CustomFieldsHelper.send(:include, ExtendedFieldsHelperPatch)
    end
end

Redmine::Plugin.register :extended_fields_plugin do
    name 'Extended fields'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com'
    description 'Adds new custom field types: Wiki text, Link and Project.'
    url 'http://projects.andriylesyuk.com/projects/redmine-fields'
    version '0.0.1'
end
