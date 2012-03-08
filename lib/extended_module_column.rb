class ExtendedModuleColumn < ExtendedColumn

    def initialize(project_module)
        self.name = "project_module_#{project_module}".to_sym
        self.caption = l_or_humanize(project_module, :prefix => 'project_module_')
        self.align = :center

        @module = project_module
    end

    def value(project)
        !!project.module_enabled?(@module)
    end

end
