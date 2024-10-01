namespace :lives do
    desc "Restore lives to users every 3 minutes"
    task :restore do
      # Requiere los archivos necesarios para cargar las clases y base de datos
      require_relative '/home/ricardo/Escritorio/AyD_Taller_TrucoArgentino/models/user.rb'
      require_relative '/home/ricardo/Escritorio/AyD_Taller_TrucoArgentino/models/life.rb'
  
      interval = 3.minutes
  
      # Lógica para restaurar vidas
      User.joins(:lives).where('lives.updated_at <= ?', Time.now - interval).each do |user|
        user.lives.each do |life|
          max_lives = 3
  
          time_passed = Time.now - life.updated_at
          lives_to_restore = (time_passed / interval).to_i
  
          if lives_to_restore > 0
            new_life_count = [life.cantidadDeVidas + lives_to_restore, max_lives].min
            life.update!(cantidadDeVidas: new_life_count, updated_at: Time.now)
          end
        end
      end
    end
  end
  
  