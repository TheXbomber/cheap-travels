### SEARCH TEST

Given('the user is in the home page') do
    # pending # Write code here that turns the phrase above into concrete actions
    visit(root_path)
    expect(page.current_path).to eq(root_path)
end

When('they insert {string} in the origin form field') do |string|
    # pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "origin", :with => string
    end
end

When('they insert {string} in the departure form field') do |string|
    # pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "departure", :with => string
    end
end

When('they insert {string} in the return form field') do |string|
    # pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "return", :with => string
    end
end

When('they insert {string} in the budget form field') do |string|
    # pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "budget", :with => string
    end
end

When('they insert {string} in the people form field') do |string|
    # pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "people", :with => string
    end
end

When('they click on the search button') do
    # pending # Write code here that turns the phrase above into concrete actions
    click_button(id: "cerca", disabled: true)
end

Then('they should be redirected to the results page') do
    # pending # Write code here that turns the phrase above into concrete actions
    expect(page.current_path).to eq(search_results_path)
end

Then('should see the map with the destinations') do
    # pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_selector("#my-map")
end

Then('should see a list of the destinations') do
    # pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_selector("#results_div")
end

#### REVIEW TEST

Given('the user has previously registered with username {string}') do |string|
    # pending # Write code here that turns the phrase above into concrete actions
    visit(new_user_registration_path)
    expect(page).to have_selector("#reg-div")
    if string.length != 0
        fill_in "user[name]", :with => string
    end
end
  
Given('with email {string}') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "user[email]", :with => string
    end
end

Given('with password {string}') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "user[password]", :with => string
        fill_in "user[password_confirmation]", :with => string
    end
    click_on "commit"
    visit("/MAD/2022-08-01/2022-08-03/1/ES/VLC/Valencia")
end

Given('has logged in with username {string}') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css(".navbar-text", text: string)
end

Given('they are in the place page') do
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page.current_path).to eq("/MAD/2022-08-01/2022-08-03/1/ES/VLC/Valencia")
end

Given('the place is {string}') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_selector("h1", text: string)
end

When('the user inserts {string} in the body field') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_selector("#rev-div")
    if string.length != 0
        fill_in "review[body]", :with => string
    end
end

When('they select {string} in the rating field') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_selector("#review_rating")
    if string.length != 0
        select string, :from => "review[rating]"
    end
end

When('they click the create review button') do
    expect(page).to have_selector("#submit-btn")
    click_on "commit"
end

Then('they should be redirected to the same page') do
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page.current_path).to eq("/MAD/2022-08-01/2022-08-03/1/ES/VLC/Valencia")
end

Then('they should see the review list') do
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_selector("#reviews-div")
end

Then('they should see a review with the author {string}') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("#user-link", text: string)
end

Then('they should see a review with the body {string}') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("#rev-body", text: string)
end

Then('they should see a review with the the rating {string}') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css(".star-on", count: string.to_i)
    expect(page).to have_css(".star-off", count: 5-string.to_i)
end

### USER REGISTRATION TEST

# Already implemented
# Given('the user is in the home page') do
#     # pending # Write code here that turns the phrase above into concrete actions
#     visit(root_path)
#     expect(page.current_path).to eq(root_path)
# end

When('the user clicks on the {string} button') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("#sign-up-btn")
    click_on "sign-up-btn"
end
  
Then('they are redirected to the sign up page') do
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page.current_path).to eq(new_user_registration_path)
end
  
Then('they insert {string} in the name field') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_selector("#reg-div")
    if string.length != 0
        fill_in "user[name]", :with => string
    end
end
  
Then('they insert {string} in the email field') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "user[email]", :with => string
    end
 end
  
Then('they insert {string} in the password field') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "user[password]", :with => string
        fill_in "user[password_confirmation]", :with => string
    end
end
  
Then('they insert {string} in the birthday field') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "user[bday]", :with => string
    end
end
  
Then('they insert {string} in the telephone field') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    if string.length != 0
        fill_in "user[tel]", :with => string
    end
end
  
Then('they click the {string} button') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    click_on "commit"
end
  
Then('they should be redirected to the home page') do
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page.current_path).to eq(root_path)
end
  
Then('if they visit their profile page') do
    #pending # Write code here that turns the phrase above into concrete actions
    #visit(users_profile_path)
    expect(page).to have_css("#profile-btn")
    click_on "profile-btn"
    expect(page.current_path).to eq(users_profile_path)
end
  
Then('they should see {string} as their profile name') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("h2", text: string)
end
  
Then('they should see {string} as their email') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("#email-field", text: string)
end
  
  Then('they should see {string} as their birthday') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("#bday-field", text: string)
  end
  
Then('they should see {string} as their telephone number') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("#tel-field", text: string)
end

Then('they should see {string} as their role') do |string|
    #pending # Write code here that turns the phrase above into concrete actions
    expect(page).to have_css("#role-field", text: string)
end
  