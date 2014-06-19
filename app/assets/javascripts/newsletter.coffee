jQuery(document).ready ($) ->

    $('form.signup').submit (e) ->
        email = $('#EMAIL').val()
        action = $(@).attr 'action'

        hiddenFieldsHTML = ''
        $(@).find('input[type="hidden"]').each ->
            hiddenFieldsHTML += """
                <input type="hidden"
                  name="#{$(@).attr 'name'}"
                  value="#{$(@).val()}"/>"""

        formHTML = """
            <form method="post" action="#{action}" accept-charset="UTF-8">
              #{hiddenFieldsHTML}
              <div class="field">
                <label for="newsletterEmail">Email</label>
                <input id="newsletterEmail" type="email" name="EMAIL"
                  value="#{email}" />
              </div>
              <div class="field">
                <label for="newsletterFName">First Name</label>
                <input id="newsletterFName" type="text" name="FNAME" />
              </div>
              <div class="field">
                <label for="newsletterLName">Last Name</label>
                <input id="newsletterLName" type="text" name="LNAME" />
              </div>
            </form>
            """

        new Skylite
            lockMask: true
            type: 'newsletter'
            title: 'Newsletter Signup'
            body: 'Get updates on Starfactory workshops and events.'
            html: formHTML
            ready: (modal) ->
                if !email
                    modal.find('#newsletterEmail').focus()
                else
                    modal.find('#newsletterFName').focus()
            actions:
                'Cancel': -> true
                'Signup': (modal) ->
                    $('body').busy()
                    modal.$modal.find('form').submit()

        e.preventDefault()
        false
