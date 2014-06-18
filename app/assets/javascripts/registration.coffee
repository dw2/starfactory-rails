jQuery(document).ready ($) ->

    stripeData = $('#stripeData').data()
    eventData = $('#eventData').data()

    handler = StripeCheckout.configure
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
        unless !!$(@).data('paid')
            handler.open
                name: 'Starfactory'
                description: eventData.name
                amount: parseInt(eventData.cost, 10)
                email: eventData.email
            e.preventDefault()
            false
