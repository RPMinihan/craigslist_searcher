#!/usr/local/bin/ruby
require 'rubygems'
require 'hpricot'
require 'open-uri'


search_string = "search/eng?addOne=telecommuting"
search_hrefs = Array.new
results = Array.new
total = 0


doc = Hpricot(open("http://geo.craigslist.org/iso/us"))
list = doc.search("//div[@id='list']")
hrefs = Array.new
list.search('a[@href]').map {|x|
	hrefs << x['href']
	}

hrefs.each{|city|
search_hrefs <<  city + search_string
}
puts "<p><em>Last Updated: #{Time.now}</em></p>"
search_hrefs.each{|city|
	city_string = city.gsub(/\/search.*/, '')	
	puts "<br><br><hr>"	
	puts "<h1><em>" + city_string + "</em></h1>"
begin	
	doc2 = Hpricot(open(city))
rescue Exception
puts "<h2><em>Website #{city_string} timed out.</em></h2>"
next
end

	x = doc2.search("//p")
	x.map{|line|
		total += 1	
      results << line.to_html.gsub(/\/.*html/, "#{city_string}" + '\0')
		  unless line.to_html.match(/http.*/) then puts line.to_html.gsub(/\/.*html/, "#{city_string}" + '\0')
      else
		  puts line.to_html	
    end
	}

}


