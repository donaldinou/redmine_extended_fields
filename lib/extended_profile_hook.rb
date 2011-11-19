class ExtendedProfileHook  < Redmine::Hook::ViewListener # PROFILE

    def view_layouts_base_html_head(context = {})
        stylesheet_link_tag('extended_profile', :plugin => 'extended_fields')
    end

    render_on :view_sidebar_author_box_bottom, :partial => 'extended_fields/author'

end
