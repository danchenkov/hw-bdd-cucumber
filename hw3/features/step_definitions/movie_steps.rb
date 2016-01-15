Given /the following movies exist/ do |movies_table|
	movies_table.hashes.each do |movie|
		Movie.create(movie)
	end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
	page.body.should =~ /#{el1}.*#{el2}/
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, ratings_list|
	ratings_list.split(%r{,\s*}).each do |rating|
		uncheck.nil? ? check("ratings_#{rating}") : uncheck("ratings_#{rating}")
	end
end

Then /I should see all the movies/ do
	Movie.all.each do |movie|
		(page.all('table#movies tr').count - 1).should == Movie.count
		if page.respond_to? :should
			page.should have_content(movie.title)
		else
			assert page.has_content?(movie.title)
		end
	end
end

Then /I should see movies with ratings: (.*)/ do |ratings_list|
	ratings_list.split(%r{,\s*}).each do |rating|
		return false unless page.has_checked_field?("ratings_#{rating}")
	end
	true
end

And /I should not see movies with ratings: (.*)/ do |ratings_list|
	ratings_list.split(%r{,\s*}).each do |rating|
		return false unless page.has_unchecked_field?("ratings_#{rating}")
	end
	true
end
