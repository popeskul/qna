# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'commentable' do
  it { should have_many(:comments).dependent(:delete_all) }
end
