# frozen_string_literal: true

# noinspection RubyResolve
begin
  GrapeSwaggerRails.options.url = '/api/v1/swagger_doc.json'
  GrapeSwaggerRails.options.app_name = 'Teneo Data Server API'
  GrapeSwaggerRails.options.app_url = '/api'
  GrapeSwaggerRails.options.api_auth = 'bearer'
  GrapeSwaggerRails.options.api_key_name = 'Authorization'
  GrapeSwaggerRails.options.api_key_type = 'header'
  GrapeSwaggerRails.options.hide_url_input = true
end