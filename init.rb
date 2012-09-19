require 'redmine'

require_dependency 'extended_fields_hook'

Rails.logger.info 'Starting Extended Fields plugin for Redmine'

Rails.configuration.to_prepare do
    require_dependency 'query'

    Redmine::CustomFieldFormat.map do |fields|
        fields.register    WikiCustomFieldFormat.new('wiki',    :label => :label_wiki_text, :order => 2.1)
        fields.register    LinkCustomFieldFormat.new('link',    :label => :label_link,      :order => 2.2)
        fields.register ProjectCustomFieldFormat.new('project', :label => :label_project,   :order => 8)
    end

    unless ActionView::Base.included_modules.include?(ExtendedFieldsHelper)
        ActionView::Base.send(:include, ExtendedFieldsHelper)
    end

    unless defined? ActiveSupport::SafeBuffer
        unless ActionView::Base.included_modules.include?(ExtendedHTMLEscapePatch)
            ActionView::Base.send(:include, ExtendedHTMLEscapePatch)
        end
    end

    unless AdminController.included_modules.include?(ExtendedAdminControllerPatch)
        AdminController.send(:include, ExtendedAdminControllerPatch)
    end
    unless UsersController.included_modules.include?(ExtendedUsersControllerPatch)
        UsersController.send(:include, ExtendedUsersControllerPatch)
    end
    unless IssuesController.included_modules.include?(ExtendedIssuesControllerPatch)
        IssuesController.send(:include, ExtendedIssuesControllerPatch)
    end
    unless CustomFieldsHelper.included_modules.include?(ExtendedFieldsHelperPatch)
        CustomFieldsHelper.send(:include, ExtendedFieldsHelperPatch)
    end
    unless QueriesHelper.included_modules.include?(ExtendedQueriesHelperPatch)
        QueriesHelper.send(:include, ExtendedQueriesHelperPatch)
    end
    unless CustomField.included_modules.include?(ExtendedCustomFieldPatch)
        CustomField.send(:include, ExtendedCustomFieldPatch)
    end
    unless CustomValue.included_modules.include?(ExtendedCustomValuePatch)
        CustomValue.send(:include, ExtendedCustomValuePatch)
    end
    unless QueryCustomFieldColumn.included_modules.include?(ExtendedQueryCustomFieldColumn)
        QueryCustomFieldColumn.send(:include, ExtendedQueryCustomFieldColumn)
    end
    unless Query.included_modules.include?(ExtendedCustomQueryPatch)
        Query.send(:include, ExtendedCustomQueryPatch)
    end
    unless Project.included_modules.include?(ExtendedProjectPatch)
        Project.send(:include, ExtendedProjectPatch)
    end
    unless User.included_modules.include?(ExtendedUserPatch)
        User.send(:include, ExtendedUserPatch)
    end

    unless AdminController.included_modules.include?(CustomFieldsHelper)
        AdminController.send(:helper, :custom_fields)
        AdminController.send(:include, CustomFieldsHelper)
    end
    unless WikiController.included_modules.include?(CustomFieldsHelper)
        WikiController.send(:helper, :custom_fields)
        WikiController.send(:include, CustomFieldsHelper)
    end

    if defined? ActionView::OptimizedFileSystemResolver
        unless ActionView::OptimizedFileSystemResolver.method_defined?(:[])
            ActionView::OptimizedFileSystemResolver.send(:include, ExtendedFileSystemResolverPatch)
        end
    end
end

Query.add_available_column(ExtendedQueryColumn.new(:notes,
                                                   :value => lambda { |issue| issue.journals.select{ |journal| journal.notes.present? }.size }))

Query.add_available_column(ExtendedQueryColumn.new(:changes,
                                                   :caption => :label_change_plural,
                                                   :value => lambda { |issue| issue.journals.select{ |journal| journal.details.any? }.size }))

Query.add_available_column(ExtendedQueryColumn.new(:watchers,
                                                   :caption => :label_issue_watchers,
                                                   :value => lambda { |issue| issue.watchers.size }))

Redmine::Plugin.register :extended_fields do
    name 'Extended fields'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com'
    description 'Adds new custom field types, improves listings etc.'
    url 'http://projects.andriylesyuk.com/projects/extended-fields'
    version '0.1.1'
end
