Feature: Write a review for a place
    The user writes a review for a place and views it

    Background: The user is logged in and is in the place page
        Given the user has previously registered with username "testuser"
        And with email "testuser@test.com"
        And with password "testuserpass"
        And has logged in with username "testuser"
        And they are in the place page

    Scenario: The user gets to the results page
        Given the place is "Valencia"
        When the user inserts "This is a review" in the body field
        And they select "4" in the rating field
        And they click the create review button
        Then they should be redirected to the same page
        And they should see the review list
        And they should see a review with the author "testuser"
        And they should see a review with the body "This is a review"
        And they should see a review with the the rating "4"
        