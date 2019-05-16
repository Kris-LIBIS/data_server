module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :organizations, [Types::OrganizationType], null: false

    def organizations
      Teneo::DataModel::Organization.all
    end

  end
end
