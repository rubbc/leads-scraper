require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require 'csv'
require './scraper'
require './name_page_scraper'

def transfer

  csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
  filepath = 'leads.csv'

  CSV.open(filepath, 'wb', csv_options) do |csv|
    csv << ["Name", "address"]
    @leads.uniq.each do |lead|
      csv << ["#{lead[:name]}", "#{lead[:address]}"]
    end
  end

end

transfer
