require "open-uri"
require "nokogiri"
require_relative 'recipe'

class Service
  def initialize(keyword)
    @keyword = keyword
  end

  def scrape_recipes
    url = "https://www.allrecipes.com/search/results/?search=#{@keyword}"
    html_doc = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
    html_doc.search('.card__detailsContainer').first(5).map do |element|
      Recipe.new(name: element.search('.card__title').text.strip,
                 description: element.search('.card__summary').text.strip,
                 rating: element.search('.review-star-text').text[/\d\.*\d*/],
                 prep_time: scrape_prep_time(element.search('.card__titleLink').attribute('href').value),
                 done: false)
    end
  end

  def scrape_prep_time(href)
    html_doc = Nokogiri::HTML(URI.open(href).read, nil, 'utf-8')
    prep_time_header = html_doc.search('.recipe-meta-item div:contains("total:")').first
    prep_time_header ? prep_time_header.next_element.text.strip : 'unknown'
  end
end
