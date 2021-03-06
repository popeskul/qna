# frozen_string_literal: true

# validator for url
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || I18n.t('url_validator.error.must_be_valid')) unless url_valid?(value)
  end

  def url_valid?(url)
    url = begin
      URI.parse(url)
    rescue StandardError
      false
    end
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end
end
