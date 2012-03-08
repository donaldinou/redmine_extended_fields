class ExtendedTrackerColumn < ExtendedColumn

    def initialize(tracker, options = {})
        if options[:open]
            self.name = "open_#{tracker.name.downcase.gsub(%r{[^a-z0-9_]}i, '_')}_issues".to_sym
            self.caption = l(:label_open_tracker_column, :tracker => tracker.name)
        else
            self.name = "#{tracker.name.downcase.gsub(%r{[^a-z0-9_]}i, '_')}_issues".to_sym
            self.caption = l(:label_tracker_column, :tracker => tracker.name)
        end
        self.align = :center

        @options = options
        @css_classes = 'tracker'
        @tracker = tracker
    end

    def value(project)
        if @options[:open]
            Issue.open.count(:conditions => [ "project_id = ? AND tracker_id = ?", project.id, @tracker.id ])
        else
            Issue.count(:conditions => [ "project_id = ? AND tracker_id = ?", project.id, @tracker.id ])
        end
    end

end
