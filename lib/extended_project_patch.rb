require_dependency 'project'

module ExtendedProjectPatch

    def self.included(base)
        base.extend(ClassMethods)
    end

    module ClassMethods

        @@available_columns = [
            ExtendedColumn.new(:project, :css_classes => 'name'),
            ExtendedColumn.new(:description),
            ExtendedColumn.new(:homepage),
            ExtendedColumn.new(:parent),
            ExtendedColumn.new(:is_public, :align => :center),
            ExtendedColumn.new(:created_on, :align => :center),
            ExtendedColumn.new(:updated_on, :align => :center),
            ExtendedColumn.new(:active, :align => :center)
            # TODO: ExtendedColumn.new(:downloads, SELECT SUM(downloads) FROM attachments WHERE (container_type = 'Project' AND container_id = 1) OR (container_type = 'Version' AND container_id IN (SELECT id FROM versions WHERE project_id = 1)) :align => :center)
        ]

        def available_columns
            @@available_columns + ProjectCustomField.all.collect{ |column| ExtendedCustomFieldColumn.new(column) }
        end

        def default_columns
            @@available_columns.select do |column|
                case column.name
                when :project, :is_public, :created_on
                    true
                else
                    false
                end
            end
        end

    end

end
