# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'Returnable public fields' do
  it 'return public fields' do
    fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for 'Does not returnable private fields' do
  it 'does not return public fields' do
    fields.each { |attr| expect(resource).to_not have_key(attr) }
  end
end
