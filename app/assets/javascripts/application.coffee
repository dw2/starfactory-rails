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
    $('.modal').removeClass 'active'
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
