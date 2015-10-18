class ExtendedTrackerColumn < ExtendedColumn

    def initialize(tracker, options = {})
        if options[:open]
            self.name = "open_tracker_#{tracker.id}_issues".to_sym
            @caption = :label_open_tracker_column
        else
            self.name = "tracker_#{tracker.id}_issues".to_sym
            @caption = :label_tracker_column
        end
        self.align = :center

        @options = options
        @css_classes = 'tracker'
        @tracker = tracker
    end

    def caption
        l(@caption, :tracker => @tracker.name)
    end

    def value(project)
        if @options[:open]
            Issue.open.where([ "project_id = ? AND tracker_id = ?", project.id, @tracker.id ]).count
        else
            Issue.where([ "project_id = ? AND tracker_id = ?", project.id, @tracker.id ]).count
        end
    end

end
