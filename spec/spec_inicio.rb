# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require_relative '../app'
RSpec.describe 'App' do
  it 'Mustra pantalla de incio ' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Inicio')
  end
end
