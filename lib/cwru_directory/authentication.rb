module CWRUDirectory
  class << self
    def authenticate!
      return if @authenticated
      # Surely this will return a result, then we can click 'MORE INFO'
      # which will take us to the Single Sign On
      page = @agent.get(URL + '?' + to_query_string(default_search_params.merge({surname: 'Mason', givenname: 'Andrew'})))

      # Fill out the SSO form
      login_page = page.link_with(text: 'MORE INFO').click
      login_page.form_with(name: nil) do |form|
        form.field_with(name: 'username').value = @config.case_id
        form.field_with(name: 'password').value = @config.password
      end.submit
      @authenticated = true
    end
  end
end
