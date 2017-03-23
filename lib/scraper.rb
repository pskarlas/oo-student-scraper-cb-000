require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "./fixtures/student-site/#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end


  def self.scrape_profile_page(profile_url)
    # profile_hash = {
    #   :twitter
    #   :linkedin
    #   :github 
    #   :blog
    #   :profile_quote
    #   :bio
    # }
    profile_hash = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    # binding.pry
    links = profile_page.css(".social-icon-container").children.css("a").map {|element| element.attr("href")} 
    # binding.pry
    links.each do |link|
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      else     
        profile_hash[:blog] = link
      end
    end
    if bio = profile_page.css(".description-holder p").text
      profile_hash[:bio] = bio
    end
    # Alternative statement  
    profile_hash[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    # binding.pry
    profile_hash
  end
end
