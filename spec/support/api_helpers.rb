# frozen_string_literal: true

# Helpers from v1
module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    send(method, path, options)
  end
end
