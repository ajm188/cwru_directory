require "cwru_directory/version"
require 'cwru_directory/config'
require 'cwru_directory/authentication'

require 'mechanize' # Can't just open-uri because the URL does a redirect

module CWRUDirectory
  URL = 'https://webapps.case.edu/directory/lookup'
  @agent ||= Mechanize.new

  class << self
    # Perform a simple search. Default search method is
    # regular. Other option is phonetic, which actually seems
    # to sort of work.
    #
    # Returns a hash, which maps each category (see the comments on
    # the #advanced method) to the list of results for that category.
    # Each result is itself a hash, with the keys:
    #   * :name
    #   * :phone_number
    #   * :email
    #   * :department
    def simple(search_text, search_method = :regular)
      search({search_text: search_text, search_method: search_method})
    end

    # Perform an advanced search with various params. Ones supported
    # by the CWRU directory are:
    #   * surname: last name
    #   * givenname: first name
    #   * department: not listed for most entries
    #   * location: ???
    #   * category: one of 'STUDENT', 'FACULTY', 'STAFF', or 'EMERITI'
    #   * search_text: same as the argument to the simple search
    #   * search_method: same as the argument to the simple search
    #
    # Returns a hash, exactly like the #simple method (see above)
    def advanced(params = {})
      search(params)
    end

    def search(params)
      page = @agent.get(URL + '?' + to_query_string(default_search_params.merge(params))).parser
      rows = page.xpath('//table[@class="dirresults"]/tr')
      parse_results(rows)
    end

    def parse_results(rows)
      header = nil
      results = {}
      index = 0
      while index < rows.length
        # We need more fine-grained control over the looping
        # because each result is actually 2 rows in the table,
        # but header rows are only one row. This is the worst
        row = rows[index]
        if row.children[0].get_attribute('class') == 'dirhdr'
          # This is a new header section.
          header = row.children[0].children[0].text
          results[header] = []
        elsif row.children[0].get_attribute('class') == 'breaker'
          # This row is just for spacing. Ignore it.
          index += 1
          next
        else
          # This is a result row. Process it and the next row
          results[header] << process_result(row, rows[index + 1])
          index += 1
        end
        index += 1
      end
      results
    end

    def process_result(first_row, second_row)
      {
        name: first_row.children[0].text,
        phone_number: first_row.children[1].text,
        email: second_row.children[0].text,
        department: second_row.children[1].text
      }
    end

    def default_search_params
      {
        search_text: '',
        surname: '',
        givenname: '',
        department: '',
        location: '',
        category: :all,
        search_method: :regular
      }
    end

    def to_query_string(params)
      params.map { |k,v| "#{k}=#{v}" }.join('&')
    end
  end
end
