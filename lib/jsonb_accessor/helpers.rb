# frozen_string_literal: true

module JsonbAccessor
  module Helpers
    module_function

    def active_record_default_timezone
      ActiveRecord.try(:default_timezone) || ActiveRecord::Base.default_timezone
    end

    # Replaces all keys in `attributes` that have a defined store_key with the store_key
    def convert_keys_to_store_keys(attributes, store_key_mapping)
      attributes.stringify_keys.transform_keys do |key|
        store_key_mapping[key] || key
      end
    end

    # Replaces all keys in `attributes` that have a defined store_key with the named key (alias)
    def convert_store_keys_to_keys(attributes, store_key_mapping)
      convert_keys_to_store_keys(attributes, store_key_mapping.invert)
    end

    def deserialize_value(value, attribute_type)
      return value if value.blank?

      if attribute_type == :datetime
        value = if active_record_default_timezone == :utc
                  Time.find_zone("UTC").parse(value).in_time_zone
                else
                  Time.zone.parse(value)
                end
      end

      value
    end
  end
end
