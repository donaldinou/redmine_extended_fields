require_dependency 'user'

module ExtendedUserPatch

    def self.included(base)
        base.extend(ClassMethods)
    end

    module ClassMethods

        @@available_columns = [
            ExtendedColumn.new(:login, :css_classes => 'username'),
            ExtendedColumn.new(:firstname),
            ExtendedColumn.new(:lastname),
            ExtendedColumn.new(:mail),
            ExtendedColumn.new(:admin, :align => :center),
            ExtendedColumn.new(:status, :align => :center),
            ExtendedColumn.new(:language),
            ExtendedColumn.new(:auth_source),
            ExtendedColumn.new(:created_on, :align => :center),
            ExtendedColumn.new(:updated_on, :align => :center),
            ExtendedColumn.new(:last_login_on, :align => :center)
        ]

        def available_columns
            @@available_columns + UserCustomField.all.collect{ |column| ExtendedCustomFieldColumn.new(column) }
        end

        def default_columns
            @@available_columns.select do |column|
                case column.name
                when :login, :firstname, :lastname, :mail, :admin, :created_on, :last_login_on
                    true
                else
                    false
                end
            end
        end

    end

end
