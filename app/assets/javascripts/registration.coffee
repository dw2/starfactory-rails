jQuery(document).ready ($) ->

    stripeData = $('#stripeData').data()
    eventData = $('#eventData').data()
    $price = $('[role=price]')
    $coupon = $('[role=coupon]')
    $code = $('[role=code]')
    discount = 0

    stripeHandler = StripeCheckout.configure
        key: stripeData.key
        image: stripeData.image
        token: (token, args) ->
            if !!token.id
                $('#registration_stripe_token').val token.id
                $('body').busy()
                $('#new_registration')
                    .data(paid: true)
                    .submit()
            else
                $.alert
                    lockMask: true
                    html: """
                        <h1>Error</h1>
                        <p>
                            We were unable to finalize your registration. Please
                            contact us and one of our organizers will help you out
                            ASAP. Thank you for your patience.
                        <p>
                        """
                    actions:
                        'Dismiss': -> true
                        'Contact us': -> $.location '/contact'

    $('#new_registration').submit (e) ->
        if !$(@).data('paid')
            stripeHandler.open
                name: 'Starfactory'
                description: eventData.name
                amount: parseInt(eventData.cost, 10) - discount
                email: eventData.email
            e.preventDefault()
            false

    formatCost = (cents) ->
        dollars = cents / 100
        if cents <= 0
            'Free'
        else if parseInt(dollars, 10) * 100 isnt cents
            '$49.99'
        else
            "$#{parseInt dollars, 10}"

    $coupon.on 'click', '.btn', (e) ->
        e.preventDefault()
        $input = $coupon.find 'input'
        code = $.trim $input.val().toUpperCase()
        return unless !!code
        $.ajax
            url: '/coupons/check'
            data:
                coupon:
                    code: code
                    event_id: eventData.id
            success: (data, status, xhr) ->
                if !data.success? or !data.success
                    $.alert
                        title: 'Invalid Coupon'
                        body: """
                            If you're sure your code is valid, please contact us
                            and we'll get it sorted out.
                            """
                    $input.val ''
                else
                    $code.val data.coupon.code
                    discount = parseInt data.coupon.amount_in_cents, 10
                    cost = parseInt eventData.cost, 10
                    newCost = cost - discount
                    $("<p>Coupon <strong>#{code}</strong> has been applied.</p>")
                        .hide().insertAfter($price).slideDown 500
                    $price.html """
                        <strike>#{formatCost cost}</strike>
                        #{formatCost newCost}"""
                    $coupon.remove()
