class ExtendedFieldsHook  < Redmine::Hook::ViewListener

    render_on :view_custom_fields_form_upper_box,         :partial => 'custom_fields/extended'
    render_on :view_custom_fields_form_user_custom_field, :partial => 'custom_fields/options'

end
