# frozen_string_literal: true
ActiveAdmin.register Teneo::DataModel::Run, as: 'Run' do
  menu false
  belongs_to :package, parent_class: Teneo::DataModel::Package

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
    def create; super {collection_url};end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update; super {collection_url};end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def destroy; super {back_path(anchor: 'runs')};end
  end

end
