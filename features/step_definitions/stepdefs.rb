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
  