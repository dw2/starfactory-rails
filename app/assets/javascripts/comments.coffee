jQuery(document).ready ($) ->

    $pagination = $('.pagination')
    if $pagination.length
        $pagination.filter(':last').remove() if $pagination.length > 1

        $more = $("<p><a class='more icon comments'>Load More Comments</a></p>")
            .insertAfter $('section.comments ol')
            .find('.more')
            .click (e) -> fetchComments e

        fetchComments = (e) ->
            e.preventDefault()
            page = $('section.comments').data 'page'
            return false unless ++page > 0
            $.getJSON "#{window.location.href.split(/\?/)[0]}/comments.json?page=#{page}", (res) ->
                unless !!res and res.data?
                    return $.alert 'Error loading comments.'
                if !!res.data.comments
                    $('section.comments').data page: page
                    html = ''
                    for comment in res.data.comments
                        if !!comment.author_url
                            profileHtml = """
                              <a href="#{comment.author_url}">
                                #{comment.author_avatar_html}</a>"""
                        else
                            profileHtml = comment.author_avatar_html
                        html += """
                            <li class="#{comment.css_classes}">
                              #{profileHtml}
                              <cite>#{comment.author_name}</cite>
                              <time>#{comment.created_at_formatted}</time>
                              <blockquote>#{comment.body_html}</blockquote>
                            </li>"""
                    $(html).hide().appendTo($('section.comments ol')).fadeIn 600
                    $more.remove() unless !!res.data.comments_remaining
