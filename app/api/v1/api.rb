# frozen_string_literal: true

module V1

  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    mount V1::Organizations

    add_swagger_documentation add_version: true
  end

end