jQuery(document).ready ($) ->

    if location.search.match(/register_and_vote=true/i)
        workshopData = $('#workshopData').data()

        $.register {
            title: 'Signup & Vote'
        }, {
            voteWorkshopId: workshopData.id
        }
