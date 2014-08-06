//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require skylite.min

jQuery.ajaxSetup
    beforeSend: ->
        $('body').busy()
    complete: ->
        $('body').unbusy()
    error: (xhr, status, error) ->
        $.alert error ? 'An unkown error occurred.'

jQuery.alert = (options) ->
    if typeof(options) is 'string'
        options = title: options ? 'An unexpected error occurred.'
    options.type = $.trim "#{options.type ? ''} alert"
    new Skylite options

jQuery.confirm = (options) ->
    unless options.actions? and Object.keys(options.actions).length > 1
        options.actions = $.extend {'Cancel': -> true}, options.actions
    options.type = $.trim "#{options.type ? ''} confirm"
    new Skylite options

$.location = (url) ->
    handler = (-> window.onbeforeunload)()
    window.onbeforeunload = null
    document.location = url
    setTimeout (->
        $('body').busy()
        window.onbeforeunload = handler
    ), 100

jQuery.register = (options={}, fields={}) ->
    authToken = $('head meta[name="csrf-token"]').attr 'content'
    new Skylite $.extend {
        type: 'register'
        title: 'Register'
        lockMask: true
        body: """
            <p>
                Already have an account?
                <a href="/login">Login</a>
            </p>
            <hr/>
            <form accept-charset="UTF-8" action="/users" method="post">
                <input name="utf8" type="hidden" value="✓">
                <input name="authenticity_token" type="hidden" value="#{authToken}">
                <input name="register_event_id" type="hidden" value="#{fields.eventId}">
                <input name="register_coupon_code" type="hidden" value="#{fields.couponCode}">
                <input name="register_and_vote_workshop_id" type="hidden" value="#{fields.voteWorkshopId}">
                <div class="field">
                    <label for="modal_user_student_profile_attributes_name">Full Name</label>
                    <input id="modal_user_student_profile_attributes_name" name="user[student_profile_attributes][name]" type="text">
                </div>
                <div class="field">
                    <label for="modal_user_email">Email</label>
                    <input id="modal_user_email" name="user[email]" spellcheck="false" type="email">
                </div>
                <div class="field">
                    <label for="modal_user_password">Password</label>
                    <input id="modal_user_password" name="user[password]" type="password">
                </div>
            </form>
            """
        ready: ($modal) ->
            $modal.css
                marginTop: 0
                position: 'absolute'
                top: 30 + $('body').scrollTop()
        actions:
            'Cancel': -> true
            'Submit': (modal) ->
                if !$('#modal_user_student_profile_attributes_name').val()
                    $.alert "Woops. You forgot to fill in your name."
                else if !$('#modal_user_email').val()
                    $.alert "Woops. You forgot to fill in your email address."
                else if $('#modal_user_password').val().length < 8
                    $.alert "Select a password at least 8 characters long."
                else
                    $('body')
                        .busy('Submitting Registration')
                        .removeClass 'hasMask'# Make this happen immediately
                    modal.unmask()
                    modal.$modal.find('form').submit()
                    modal.$modal.fadeOut()
                false
    }, options

jQuery.fn.busy = (text='') ->
    @addClass 'busy'
    @attr 'data-busy', text if !!text
    return @

jQuery.fn.unbusy = ->
    @removeClass 'busy'
    @removeAttr 'data-busy'
    return @

jQuery(document).ready ($) ->

    # Override rails allow action (for data-confirm)
    $.rails.allowAction = (el) ->
        message = el.data 'confirm'
        buttonText = el.data('buttontext') ? 'Ok'
        if !message or el.data('affirm')
            el.data 'affirm', false
        else
            actions = {}
            actions["#{buttonText}"] = ->
                el.data 'affirm', true
                el.get(0).click()
            $.confirm
                title: el.data 'confirm'
                actions: actions
            return false

    # Detect mobile browsers
    $.touchEnabled = typeof ontouchstart isnt 'undefined'
    $('body').addClass 'touchEnabled' if $.touchEnabled

    # Dropdown header menu
    $menu = $('body > header nav')
    $menu.on 'click', (e) ->
        $menu.toggleClass 'open'
        unless $(e.target).prop('tagName').toLowerCase() is 'a'
            e.preventDefault()
            return false
    $('html').click -> $menu.removeClass 'open'

    # DatePicker
    $('.field.datetime .day').datepicker
        button: 'Derp'
        showOn: 'button'
        dateFormat: 'yy-mm-dd'
        minDate: new Date(new Date().getTime() + 86400000)
    $('.field.datetime .day').change ->
        $(@).closest('.datetime')
            .attr 'data-val', "#{$(@).val()} @ #{$(@).siblings('select').val()}"

    # Table row click
    $('table .clickrow').each ->
        href = $(@).find('a').attr 'href'
        $tr = $(@).closest 'tr'
        $tr.css cursor: 'pointer'
        $tr.click (e) ->
            $.location href
            e.preventDefault
            false

    # Table cell click
    $('table .clickcell').each ->
        href = $(@).find('a').attr 'href'
        $td = $(@).closest 'td'
        $td.css cursor: 'pointer'
        $td.click (e) ->
            $.location href
            e.preventDefault
            false
