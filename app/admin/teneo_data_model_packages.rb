#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Package, as: 'Package' do

  belongs_to :ingest_agreement, parent_class: Teneo::DataModel::IngestAgreement
  navigation_menu :ingest_agreement

end
