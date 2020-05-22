require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require 'csv'

def scraper

  @departement_data = Array.new
  url_departement_list = "https://www.regions-et-departements.fr/departements-francais"
  html_doc_departement_list = Nokogiri::HTML(open(url_departement_list))
  html_doc_departement_list.search("tbody tr").each do |element|
    departement = {
      name: element.css("td:nth-child(2)").text,
      number: element.css("td:first-child").text
    }
    @departement_data << departement

  end

  @departement_data.each do |departement|
    departement[:name].gsub!("é", "e")
    departement[:name].gsub!("è", "e")
    departement[:name].gsub!("ô", "o")
    departement[:name].downcase!
  end
end

scraper
