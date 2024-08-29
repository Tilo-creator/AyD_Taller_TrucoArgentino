RSpec.describe "App" do 
    before(:all) do 
        @user=User.create(username: 'testnmae' , password: 'pass' , name : 'testUser', email: 'test@gmail.com')
    end 

    it "Mustra la pagina de logeo" do 
        get /login 
        expect(last_response).to be_ok 
        expect(last_response).to include"Login"
    end 

    it "Perimite al usuario ingresar a su cuenta con sus datos y redirigirlo al jeugo deseado " do 
        post/login {username: 'testnmae' , password: 'pass' , game: 'truco'}
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to ep('juego/truco')
    end 

    it "Las credecnciales osn invalidas" do 
        post /login , {username: 'usuarioIncorrecto' , password: 'contraseñaIncorrecta'}
        expect(last_response.body).to include("Credenciales incorrectas. Inténtalo de nuevo.")
    end 
end 