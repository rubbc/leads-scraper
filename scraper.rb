require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require 'csv'

def scraper
  @name_list = Array.new
  @error_names = Array.new

  @url = "https://annuaire.118000.fr/v_froncles_52"
  html_doc = Nokogiri::HTML(open(@url))
  article = html_doc.search('article')
  last_number_pagination = article.css('ul#pagination li:nth-last-child(2)').text.to_i

  last_page_url = "#{@url}/#{last_number_pagination}"
  html_doc_last_page = Nokogiri::HTML(open(last_page_url))
  article_last_page = html_doc_last_page.search('article')
  max_pagination = article_last_page.css('ul#pagination li:nth-last-child(2)').text.to_i

  pagination_start = 1

  while pagination_start <= (max_pagination + 1)
    main_url = "#{@url}/#{pagination_start}"
    main_html_doc = Nokogiri::HTML(open(main_url))
    main_article = main_html_doc.css('article')
    names = main_article.search('ul.multiple.column5 li a')
    text_names = Array.new
    names.each do |name|
      text_names << name.text
    end
    text_names.each do |name|
      name.downcase!
      name.gsub!(" ", "-")
      name.gsub!("ç", "c")
      name.gsub!("é", "e")
      name.gsub!("è", "e")
      name.gsub!("â", "a")
      name.gsub!("ô", "o")
      name.gsub!("'", "")
      @name_list << name
      url_check = "#{@url}/n_#{name}"
      begin
        file = open(url_check)
        doc = Nokogiri::HTML(file) do
        end
      rescue OpenURI::HTTPError => e
        if e.message == '404 Not Found'
          @error_names << name
          @name_list.delete(name)
          pagination_start += 1
        else
          raise e
        end
      end
    end
    pagination_start += 1
  end
  # binding.pry
end

scraper
