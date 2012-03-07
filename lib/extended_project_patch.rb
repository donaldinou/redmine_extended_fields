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
            ExtendedColumn.new(:is_public,  :align => :center),
            ExtendedColumn.new(:created_on, :align => :center),
            ExtendedColumn.new(:updated_on, :align => :center),
            ExtendedColumn.new(:active,     :align => :center),
            ExtendedColumn.new(:downloads,
                               :value => lambda { |project| Attachment.sum(:downloads,
                                                                           :conditions => [ "(container_type = 'Project' AND container_id = ?) OR (container_type = 'Version' AND container_id IN (?))", project.id, project.versions.collect{ |version| version.id } ]) },
                               :align => :center),
            ExtendedColumn.new(:maximum_downloads,
                               :caption => :label_maximum_downloads,
                               :value => lambda { |project| Attachment.maximum(:downloads,
                                                                               :conditions => [ "(container_type = 'Project' AND container_id = ?) OR (container_type = 'Version' AND container_id IN (?))", project.id, project.versions.collect{ |version| version.id } ]) },
                               :align => :center),
            ExtendedColumn.new(:latest_version,
                               :caption => :label_latest_version,
                               :value => lambda { |project| project.versions.sort.reverse.select{ |version| version.closed? }.first },
                               :align => :center),
            ExtendedColumn.new(:next_version,
                               :caption => :label_next_version,
                               :value => lambda { |project| project.versions.sort.select{ |version| !version.closed? }.first },
                               :align => :center),
            ExtendedColumn.new(:issues,
                               :caption => :label_issue_plural,
                               :value => lambda { |project| project.issues.count },
                               :align => :center),
            ExtendedColumn.new(:open_issues,
                               :caption => :field_open_issues,
                               :value => lambda { |project| project.issues.open.count },
                               :align => :center),
            ExtendedColumn.new(:last_activity,
                               :caption => :label_last_activity,
                               :value => lambda { |project| (event = Redmine::Activity::Fetcher.new(User.current, :project => project).events(nil, nil, :limit => 1).first) && event.event_date },
                               :align => :center),
            ExtendedColumn.new(:repository,
                               :caption => :label_repository,
                               :value => lambda { |project| !!project.repository },
                               :align => :center)
        ]

        def available_columns
            columns = @@available_columns.dup
            Tracker.all.each do |tracker|
                columns << ExtendedTrackerColumn.new(tracker)
                columns << ExtendedTrackerColumn.new(tracker, :open => true)
            end
            IssueStatus.all.each do |status|
                columns << ExtendedIssueStatusColumn.new(status)
            end
            columns += ProjectCustomField.all.collect{ |column| ExtendedCustomFieldColumn.new(column) }
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
