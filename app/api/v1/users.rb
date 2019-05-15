# frozen_string_literal: true

class V1::Users < Grape::API

  namespace :users do

    get do
      Teneo::DataModel::User.all
    end

    get ':uuid' do
      Teneo::DataModel::User.find_by!(uuid: params[:uuid])
    end


  end

end