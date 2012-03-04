class UserListSetting < ActiveRecord::Base
    belongs_to :user

    SUPPORTED_LISTS = [ :users, :projects ]

    serialize :columns, Array

    validates_presence_of :user, :list, :columns
    validates_uniqueness_of :user_id, :scope => :list
    validates_inclusion_of :list, :in => SUPPORTED_LISTS

    def initialize(attributes = nil)
        super
        self.columns ||= User.default_columns
    end

    def columns=(fields)
        if fields.is_a?(Array)
            write_attribute(:columns, fields.collect{ |field| field.is_a?(ExtendedColumn) ? field.name.to_sym : field.to_sym })
        else
            self.columns = [ fields ]
        end
    end

    def columns
        fields = read_attribute(:columns) || User.default_columns.collect{ |column| column.name }

        available_columns = User.available_columns.inject({}) do |hash, column|
            hash[column.name] = column
            hash
        end

        fields.inject([]) do |array, field|
            if available_columns[field.to_sym]
                array << available_columns[field.to_sym]
            end
            array
        end
    end

end
