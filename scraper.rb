require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require 'csv'

def scraper
  @name_list = Array.new

  @url = "https://annuaire.118000.fr/v_froncles_52"
  html_doc = Nokogiri::HTML(open(@url))
  article = html_doc.search('article')
  last_number_pagination = article.css('ul#pagination li:nth-last-child(2)').text.to_i

  last_page_url = "#{@url}/#{last_number_pagination}"
  html_doc_last_page = Nokogiri::HTML(open(last_page_url))
  article_last_page = html_doc_last_page.search('article')
  max_pagination = article_last_page.css('ul#pagination li:nth-last-child(2)').text.to_i

  pagination_start = 1

  while pagination_start < (max_pagination + 1)
    main_url = "https://annuaire.118000.fr/v_froncles_52/#{pagination_start}"
    main_html_doc = Nokogiri::HTML(open(main_url))
    main_article = main_html_doc.css('article')
    names = main_article.search('ul.multiple.column5 li a')
    names.each do |name|
      @name_list << name.text
    end
    pagination_start += 1
  end

  @name_list.each do |name|
    name.downcase!
    name.gsub!(" ", "-")
    name.gsub!("é", "e")
    name.gsub!("è", "e")
    name.gsub!("â", "a")
    name.gsub!("ô", "o")
    name.gsub!("'", "")
  end

  names_error = ["greard", "adele"]
  names_error.each do |name|
    @name_list.delete(name)
  end
  # binding.pry
end

scraper
