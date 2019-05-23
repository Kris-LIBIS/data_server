#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Manifestation, as: 'Manifestation' do

  belongs_to :ingest_model, parent_class: Teneo::DataModel::IngestModel
  navigation_menu :ingest_model

end
