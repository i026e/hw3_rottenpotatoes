# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|	
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
	Movie.create(:title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"])
    
  end
  
end


Then /^I should see: (.*)$/ do |rating_list|
	ratings = rating_list.split(",").each {|t| t.strip!}

	actual = page.all('#movies tbody tr td[2]').collect(&:text) 
    actual.map do |cell|
		ratings.should include(cell)
	end
end

Then /^I should not see: (.*)$/ do |rating_list|
	ratings = rating_list.split(",").each {|t| t.strip!}
	actual = page.all('#movies tbody tr td[2]').collect(&:text) 
	ratings.each do |rating|
		actual.should_not include(rating)
	end

end

Then /the following checkboxes should be selected: (.*)/ do |rating_list|
	checkboxes = rating_list.split(",").each {|t| t.strip!}
	checkboxes.each do |chbox|
		field_checked = find_field('ratings_'+chbox)['checked']
		field_checked.should be_true
	end
end

Then /I should see all of the movies/ do
	table = page.all('#movies tbody tr')
	table.length.should == Movie.count
end



# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
	table = page.all('#movies tbody tr td[1]').map(&:text)
    #puts table
	table.index(e1).should < table.index(e2)
	
end

Then /order should be/ do |order|
	correct = order.hashes.collect {|x| x['title']}
	actual = page.all('#movies tbody tr td[1]').map(&:text)
	actual.should == correct
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
	ratings = rating_list.split(",").each {|t| t.strip!}
	ratings.each do |rating|
		if uncheck.nil?
			check('ratings_'+rating)
		else
			uncheck('ratings_'+rating)
		end
	end
end
