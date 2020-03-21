require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student = []
    html = Nokogiri::HTML(open(index_url))
    index = profile_page.css("div.social-icon-container").children.css("a").map (|el| el.attributes('herf').value)
    index.each do |link|
      if link.include?("linkedin")
        student[:location] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
  end

  def self.scrape_profile_page(profile_url)
    profile_html = open(profile_url)
    profile_doc = Nokogiri::HTML(profile_html)
    attributes = {}
    profile_doc.css("div.social-icon-container a").each do |link_xml|
      case link_xml.attribute("href").value
      when /twitter/
        attributes[:twitter] = link_xml.attribute("href").value
      when /github/
        attributes[:github] = link_xml.attribute("href").value
      when /linkedin/
        attributes[:linkedin] = link_xml.attribute("href").value
      else
          attributes[:blog] = link_xml.attribute("href").value
      end
    end
    attributes[:profile_quote] = profile_doc.css("div.profile-quote").text
    attributes[:bio] = profile_doc.css("div.bio-content div.description-holder").text.strip
    attributes
  end

end
