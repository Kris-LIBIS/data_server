# frozen_string_literal: true

# noinspection ALL
module V1

  class API < Grape::API
    version 'v1', using: :path
    format :json

    mount V1::Organizations
    mount V1::Users

    add_swagger_documentation add_version: true
  end

end