Feature: The user register an account
    The user registers an account by inserting their personal information in the form

    Scenario: The user successfully registers an account
        Given the user is in the home page
		When the user clicks on the "Sign up" button
		Then they are redirected to the sign up page
		And they insert "User" in the name field
		And they insert "test@test.com" in the email field
		And they insert "userpass" in the password field
		And they insert "1985-04-27" in the birthday field
		And they insert "4527390" in the telephone field
		And they click the "Sign up" button
		Then they should be redirected to the home page
		And if they visit their profile page
		Then they should see "User" as their profile name
		And they should see "test@test.com" as their email
		And they should see "1985-04-27" as their birthday
		And they should see "4527390" as their telephone number
		And they should see "user" as their role
		

        
        