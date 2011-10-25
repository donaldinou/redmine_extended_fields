class ProjectCustomFieldFormat < Redmine::CustomFieldFormat

    def format_as_project(value)
        Project.find(value).name
    rescue
        nil
    end

    def edit_as
        'list'
    end

end
