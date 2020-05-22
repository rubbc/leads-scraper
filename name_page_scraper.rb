require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require 'csv'
require './scraper'

def scraper

  @leads = Array.new
  @name_list.first(400).each do |name|
    url_name = "#{@url}/n_#{name}"
    html_doc = Nokogiri::HTML(open(url_name))
    cards = html_doc.search('article.cardlist section.card')

    cards.each do |card|
      lead = {
        name: card.css('h2').text,
        address: card.css('div.address').text
      }
      @leads << lead
    end
  end

end

scraper
