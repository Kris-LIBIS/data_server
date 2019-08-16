#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Package, as: 'Package' do

  belongs_to :ingest_workflow, parent_class: Teneo::DataModel::IngestWorkflow

end
