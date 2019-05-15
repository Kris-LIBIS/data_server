# frozen_string_literal: true

class V1::Organizations < Grape::API

  namespace 'organization' do

    get do
      Teneo::DataModel::Organization.all
    end

    get ':id' do
      Teneo::DataModel::Organization.find_by(id: params[:id])
    end

  end

end