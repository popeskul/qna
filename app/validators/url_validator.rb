class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'must be a valid URL') unless url_valid?(value)
  end

  def url_valid?(url)
    puts 'url_valid?'
    url = begin
            URI.parse(url)
          rescue
            false
          end
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end
end