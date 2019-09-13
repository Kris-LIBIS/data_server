# frozen_string_literal: true

class Admin::Converters::AddParameterForm
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :converter
  attr_accessor :parameter_name
  attr_accessor :parameter_value

  def initialize(converter_id)
    @converter = Teneo::DataModel::Converter.find(converter_id)
  end

  def submit(params)
    @params = params
    return false unless valid?

    parameter = Teneo::DataModel::ParameterDef.create(
        name: @params.fetch(:parameter_name),
        data_type: @params.fetch(:parameter_type),
        with_parameters_id: @params.fetch(:with_parameters_id),
        with_parameters_type: @params.fetch(:with_parameters_type)
    )
    parameter.save!
    true
  rescue => e
    Rails.logger.error e
    false
  end

  def valid?
    found = Teneo::DataModel::ParameterDef.find_by(
        with_parameters_type: @params.fetch(:with_parameters_type),
        with_parameters_id: @params.fetch(:with_parameters_id),
        name: @params.fetch(:parameter_name),
    ).count

    errors.add(:base, 'Parameter already exists') if found
    found.nil?
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Teneo::DataModel::Converter')
  end

end