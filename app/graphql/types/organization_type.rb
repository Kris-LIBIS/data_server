
module Types
  class OrganizationType < Types::BaseObject
    field :name, String, null: true
    field :inst_code, String, null: true
    field :ingest_dir, String, null: true
    # field :upload_areas, [Types::UploadAreaType], null: true
    # field :storages, [Types::StorageType], null: true
    # field :ingest_agreements, [Types::IngestAgreementType], null: true
  end
end
