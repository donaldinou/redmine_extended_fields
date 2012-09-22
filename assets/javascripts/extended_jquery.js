function toggle_extended_field_format() {
    format = $('#custom_field_field_format')[0];
    required = $('#custom_field_is_required')[0];
    p_length = $('#custom_field_min_length')[0];
    p_regexp = $('#custom_field_regexp')[0];
    p_default = $('#custom_field_default_value')[0];

    default_value = null;
    switch (p_default.tagName.toLowerCase()) {
        case 'input':
            switch (p_default.type.toLowerCase()) {
                case 'checkbox':
                    default_value = p_default.checked;
                    break;
                default:
                    default_value = p_default.value;
                    break;
            }
            break;
        default:
            default_value = p_default.value;
            break;
    }

    switch (format.value) {
        case 'text':
        case 'wiki':
            if (p_default.tagName.toLowerCase() != 'textarea') {
                $(p_default).replaceWith(jQuery('<textarea />', { id:   'custom_field_default_value',
                                                                  name: 'custom_field[default_value]',
                                                                  cols: 40,
                                                                  rows: 15 }).text(default_value));
            }
            break;
        case 'bool':
            if ((p_default.tagName.toLowerCase() != 'input') && (p_default.type.toLowerCase() != 'checkbox')) {
                $(p_default).replaceWith(jQuery('<input />', { type:    'checkbox',
                                                               id:      'custom_field_default_value',
                                                               name:    'custom_field[default_value]',
                                                               value:   1,
                                                               checked: default_value }));
            }
            break;
        case 'project':
            var select = jQuery('<select />', { id:   'custom_field_default_value',
                                                name: 'custom_field[default_value]' });
            if (required.checked) {
                if (default_value == "") {
                    select.prepend(jQuery('<option />').text(actionview_instancetag_blank_option));
                }
            } else {
                select.prepend(jQuery('<option />'));
            }
            for (var i = 0; i < projects.length; i++) {
                var option = jQuery('<option />', { value: projects[i][0] }).text(projects[i][1])
                if (projects[i][0] == default_value) {
                    option.selected = true;
                }
                select.prepend(option);
            }
            $(p_default).replaceWith(select);
            break;
        case 'user':
        case 'version':
            break;
        default:
            if ((p_default.tagName.toLowerCase() != 'input') && (p_default.type.toLowerCase() != 'text')) {
                $(p_default).replaceWith(jQuery('<input />', { type:  'text',
                                                               id:    'custom_field_default_value',
                                                               name:  'custom_field[default_value]',
                                                               value: default_value,
                                                               size:  30 }));
            }
            break;
    }

    switch (format.value) {
        case 'wiki':
            p_regexp.parentNode.hide();
            break;
        case 'project':
            p_length.parentNode.hide();
            p_regexp.parentNode.hide();
            break;
        default:
            break;
    }
}
