require 'spect_helper'
require 'rack/test' 
require_relative '/home/fran/Escritorio/AyD_Taller_TrucoArgentino/app.rb'
RSpec.describe "App" do 
    it "Mustra pantalla de incio " do 
        get '/'
        expect(last_response).to be_ok
        expect(last_response.body).to include("Inicio")
    end
end