function toggle_extended_field_format() {
    format = $('#custom_field_field_format')[0];
    required = $('#custom_field_is_required')[0];
    p_default = $('#custom_field_default_value')[0];

    switch (format.value) {
        case 'text':
        case 'wiki':
            if (p_default.tagName.toLowerCase() != 'textarea') {
                $(p_default).replaceWith(jQuery('<textarea />', { id:   'custom_field_default_value',
                                                                  name: 'custom_field[default_value]',
                                                                  cols: 40,
                                                                  rows: 15 }).text(p_default.value));
            }
            break;
        case 'project':
            var select = jQuery('<select />', { id:   'custom_field_default_value',
                                                name: 'custom_field[default_value]' });
            if (required.checked) {
                if (p_default.value == "") {
                    select.prepend(jQuery('<option />').text(actionview_instancetag_blank_option));
                }
            } else {
                select.prepend(jQuery('<option />'));
            }
            for (var i = 0; i < projects.length; i++) {
                var option = jQuery('<option />', { value: projects[i][0] }).text(projects[i][1])
                if (projects[i][0] == p_default.value) {
                    option.selected = true;
                }
                select.prepend(option);
            }
            $(p_default).replaceWith(select);
            break;
        default:
            break;
    }
}
