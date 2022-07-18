Feature: Find destinations after search
    The user obtains the list of the cheaptest destinations according to their search parameters

    Scenario: The user gets to the results page
        Given the user is in the home page
        When they insert "BER" in the origin form field
        And they insert "2022-08-01" in the departure form field
        And they insert "2022-08-03" in the return form field
        And they insert "1000" in the budget form field
        And they insert "1" in the people form field
        And they click on the search button
        Then they should be redirected to the results page
        And should see the map with the destinations
        And should see a list of the destinations