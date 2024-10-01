require './app' # Asegúrate de que esto esté correcto según tu estructura de archivos
require './models/statistic'
require './models/life'

require './models/level' # Asegúrate de que la ruta sea correcta

# Crear usuarios
users = [
  { names: 'Jon Doe', username: 'jondoe', email: 'jon@doe.com', password: 'abc', isAdmin:'false' },
  { names: 'Jane Doe', username: 'janedoe', email: 'jane@doe.com', password: 'abc', isAdmin:'false' },
  { names: 'Baby Doe', username: 'babydoe', email: 'baby@doe.com', password: 'abc', isAdmin:'false' },
  { names: 'Riacardo Trimboli', username: 'Tilo', email: 'riki.trimboli@gmail.com', password: '1234', isAdmin: 'true'},
]


users.each do |user_data|
  user = User.create(user_data)
  if user.persisted?
    # Crear un nivel asociado con level_number en 0
    user.create_level(level_number: 0)
    puts "Usuario #{user.username} creado con nivel inicial."
  else
    puts "Error al crear usuario #{user_data[:username]}: #{user.errors.full_messages.join(', ')}"
  end
end
users.each do |u|
  User.create(u)
end

# Crear niveles para usuarios existentes
Level.create(level_number: 1, user_id: 1)
Level.create(level_number: 1, user_id: 2)

# Semillas para las lecciones
lessons = [
  # Lecciones para el capítulo 1
  { title: "Tipo de Mazo", description: "El truco se juega con un mazo español de 40 cartas, excluyendo los ochos y nueves. Este mazo está compuesto por cuatro palos: oros, copas, espadas y bastos. Cada palo tiene cartas numeradas del 1 al 7 y las figuras que son el 10 (sota), 11 (caballo) y 12 (rey). El mazo español es tradicional en muchos juegos de cartas en España y América Latina, y su uso en el truco es una característica distintiva del juego.", chapter: "Con qué tipo de mazo se juega y con qué cartas del mismo" },
  { title: "Cartas del Mazo", description: "Las cartas del mazo español incluyen oros, copas, espadas y bastos, con valores del 1 al 7 y 10 a 12. En el truco, las figuras (10, 11 y 12) no tienen el mismo valor numérico que en otros juegos, ya que el 10, 11 y 12 corresponden a sota, caballo y rey respectivamente. Este sistema de numeración es importante para entender cómo se juega y se puntúa en el truco.", chapter: "Con qué tipo de mazo se juega y con qué cartas del mismo" },
  { title: "El Valor de las Cartas", description: "Cada carta tiene un valor que varía según la jugada y el contexto del juego. Por ejemplo, el 1 de espadas (espada limpia) y el 1 de bastos (basto limpio) son las cartas más poderosas, seguidas por el 7 de espadas y el 7 de oros. Este orden específico de las cartas es fundamental para las estrategias del juego y debe ser aprendido cuidadosamente.", chapter: "Con qué tipo de mazo se juega y con qué cartas del mismo" },
  { title: "Cartas Más Débiles", description: "Las cartas más débiles son las de valor más bajo, como el 4 de copas, 4 de oros, 5 de copas y 5 de oros. Aunque estas cartas no son útiles para ganar en la mayoría de las manos, pueden ser importantes en estrategias defensivas y para engañar al oponente.", chapter: "El rango de las cartas más débiles a las más fuertes" },
  { title: "Cartas Intermedias", description: "Cartas como el 6 de cualquier palo, el 7 de copas y 7 de bastos tienen un valor intermedio. Estas cartas pueden ser útiles en ciertas jugadas y pueden ayudar a fortalecer una mano que inicialmente no parece fuerte. Su valor depende mucho del contexto y de las cartas del oponente.", chapter: "El rango de las cartas más débiles a las más fuertes" },
  { title: "Cartas Más Fuertes", description: "Las cartas más fuertes incluyen el 1 de espadas, 1 de bastos, 7 de espadas y 7 de oros. Estas cartas tienen un valor alto y son decisivas en muchas jugadas. Conocer cuáles son las cartas más fuertes te permitirá desarrollar mejores estrategias y aumentar tus posibilidades de ganar.", chapter: "El rango de las cartas más débiles a las más fuertes" },
  { title: "Juego Individual", description: "En partidas de uno contra uno, cada jugador maneja su propia estrategia sin depender de otros. La clave está en observar las cartas jugadas por el oponente y calcular las probabilidades de las cartas restantes. El juego individual es más directo y se basa en el cálculo y la habilidad personal.", chapter: "Conceptos dependiendo cantidad de jugadores" },
  { title: "Juego en Parejas", description: "En partidas de dos contra dos, la comunicación y señas entre compañeros son cruciales. Las señas permiten a los compañeros transmitir información sobre sus cartas sin que el oponente lo note. Es importante establecer un sistema de señas antes de comenzar a jugar y practicarlo para evitar errores.", chapter: "Conceptos dependiendo cantidad de jugadores" },
  { title: "Juego en Equipos", description: "En partidas con más jugadores, las estrategias se complican y la coordinación en equipo es esencial. Cada jugador debe conocer su rol y cómo apoyar a sus compañeros. Las estrategias deben ser más flexibles para adaptarse a las jugadas de los oponentes y las decisiones de los compañeros.", chapter: "Conceptos dependiendo cantidad de jugadores" },
  { title: "Número de Manos", description: "Una ronda de truco se compone de tres manos. El ganador de dos de las tres manos gana la ronda. Cada mano es una oportunidad para los jugadores de mostrar su habilidad y estrategia. Entender cuántas manos son necesarias para ganar una ronda es esencial para planificar tus jugadas.", chapter: "Cuántas manos tiene una ronda de juego y en qué momento finaliza una ronda de juego" },
  { title: "Finalización de la Ronda", description: "Una ronda finaliza cuando uno de los jugadores gana dos manos, o en caso de empate, cuando se resuelve la mano final. Esto significa que cada mano es crucial y puede determinar el resultado de la ronda. Los jugadores deben estar atentos y adaptar sus estrategias a medida que avanza la ronda.", chapter: "Cuántas manos tiene una ronda de juego y en qué momento finaliza una ronda de juego" },
  { title: "Empates en Manos", description: "En caso de empate en una mano, se considera ganada por el jugador o equipo que ganó la mano previa. Si la primera mano resulta en empate, la ventaja es para el equipo mano, es decir, el que juega primero. Este conocimiento puede influir en las decisiones estratégicas durante el juego.", chapter: "Cuántas manos tiene una ronda de juego y en qué momento finaliza una ronda de juego" },
  { title: "Canto de Envido", description: "El envido es un canto que se realiza antes de jugar la primera carta, basado en el valor de las cartas del mismo palo. El envido puede sumar muchos puntos si se tienen cartas adecuadas. Conocer cuándo y cómo cantar envido es crucial para maximizar tus puntos.", chapter: "Cuales son los distintos tipos de cantos que hay" },
  { title: "Canto del Real Envido", description:"El Real Envido es un canto como el Envido, pero la diferencia es que vale 3 puntos que se puede acumula con el canto del envido si se hizo antes", chapter: "Cuales son los distintos tipos de cantos que hay"},
  { title: "Canto del FaltaEnvido", description:"El Falta Envido es un canto como el envido pero este le da algandor los puntos que les falte al contrincante para ganar", chapter: "Cuales son los distintos tipos de cantos que hay"},
  { title: "Canto de Truco", description: "El truco es un canto que puede ser realizado en cualquier momento del juego y aumenta el valor de la mano. Al cantar truco, desafías al oponente a aceptar o rechazar el reto. Si el oponente acepta y pierde, tú ganas más puntos. Sin embargo, si aceptan y ganan, ellos obtienen los puntos adicionales, que son 2 puntos.", chapter: "Cuales son los distintos tipos de cantos que hay" },
  { title: "Canto de Retruco y Vale Cuatro", description: "El retruco y vale cuatro son cantos que incrementan aún más el valor de la mano, 3 puntos para el retruco y 4 para vale cuatro.  Estos cantos son utilizados en situaciones estratégicas para presionar al oponente y forzarlo a tomar decisiones arriesgadas. Conocer cuándo utilizar estos cantos puede cambiar el rumbo del juego.", chapter: "Cuales son los distintos tipos de cantos que hay" },
  { title: "Contar los Puntos del Envido", description: "Los puntos del envido se cuentan sumando el valor de dos cartas del mismo palo, más 20 puntos. Si un jugador tiene dos 7 del mismo palo, su envido es 27 puntos (7 + 7 + 20). Comprender cómo contar los puntos del envido es fundamental para evaluar tus posibilidades y decidir si quieres cantar o aceptar un envido.", chapter: "Contar los puntos y en qué orden van cantando los jugadores sus puntos" },
  { title: "Canto de Puntos", description: "El canto de puntos se realiza en orden, comenzando por el jugador que ganó la mano anterior. Cada jugador tiene la oportunidad de cantar sus puntos, y el jugador con el puntaje más alto gana los puntos en juego. Este proceso de canto permite a los jugadores evaluar sus manos y tomar decisiones informadas.", chapter: "Contar los puntos y en qué orden van cantando los jugadores sus puntos" },
  { title: "Marcador y Puntos Ganados", description: "El marcador registra los puntos ganados por cada jugador o equipo y determina el ganador final. Es importante llevar un registro preciso de los puntos para evitar confusiones y disputas durante el juego. Conocer cómo funciona el sistema de puntuación te permitirá seguir el progreso del juego y planificar tus estrategias a largo plazo.", chapter: "Contar los puntos y en qué orden van cantando los jugadores sus puntos" }
]

lessons.each do |lesson|
  Lesson.create(lesson)
end



Question.create(
  description: "¿Cuántas cartas se reparten a cada jugador al comienzo de una partida de Truco?",
  options: "3, 4, 6, 9",
  correct_answer: "3"
)

Question.create(
  description: "En el Truco Argentino, ¿cuál es el valor más alto de las cartas?",
  options: "Espada, Oro, Copa, Basto",
  correct_answer: "Espada"
)

Question.create(
  description: "¿Cuántos puntos debe alcanzar un equipo para ganar una partida de Truco Argentino?",
  options: "15, 20, 30, 40",
  correct_answer: "30"
)

Question.create(
  description: "¿Cuál es la carta que se considera el 'Ancho de Espada' en el Truco Argentino?",
  options: "As de Espada, Sota de Espada, Caballo de Espada, Rey de Espada",
  correct_answer: "As de Espada"
)

Question.create(
  description:"¿Cuantas cartas tiene el mazo?",
  options: "42, 50, 40, 48",
  correct_answer: "40"
)

Question.create(
  description:"¿Cuantas rondas tiene una partida?",
  options: "2, 3, 4, 5",
  correct_answer: "3"
)
Question.create(
  description:"¿cuantos puntos vale el Envido?",
  options:"1,2,3,4",
  correct_answer:"2"
)
Question.create(
  description:"¿cuantos puntos vale el Real Envido?",
  options:"1,2,3,4",
  correct_answer:"3"
)
Question.create(
  description:"¿cuantos puntos vale el Truco?",
  options:"1,2,3,4",
  correct_answer:"2"
)
Question.create(
  description:"¿cuantos puntos vale el ReTruco?",
  options:"1,2,3,4",
  correct_answer:"3"
)
Question.create(
  description:"¿cuantos puntos vale el ValeCruatro?",
  options:"1,2,3,4",
  correct_answer:"4"
)
puts "¡Se crearon las preguntas sobre el Truco Argentino!"
# Crear estadísticas
statistics = [
  {cantidadDePreguntaRespondidas: "0", cantPregRespondidasBien: "0", CantPregRespondidasMal: "0", user_id: "1"},
  {cantidadDePreguntaRespondidas: "0", cantPregRespondidasBien: "0", CantPregRespondidasMal: "0", user_id: "2"},
  {cantidadDePreguntaRespondidas: "0", cantPregRespondidasBien: "0", CantPregRespondidasMal: "0", user_id: "3"},
  {cantidadDePreguntaRespondidas: "0", cantPregRespondidasBien: "0", CantPregRespondidasMal: "0", user_id: "4"},
  { cantidadDePreguntaRespondidas: 0, cantPregRespondidasBien: 0, cantPregRespondidasMal: 0, user_id: 1, total_points: 0 },
  { cantidadDePreguntaRespondidas: 0, cantPregRespondidasBien: 0, cantPregRespondidasMal: 0, user_id: 2, total_points: 0 },
]

statistics.each do |statistic|
  Statistic.create(statistic)
end
puts "se cargaron las estadisticas"

lives =[
  {cantidadDeVidas: "3", user_id: "1"},
  {cantidadDeVidas: "3", user_id: "2"},
  {cantidadDeVidas: "3", user_id: "3"},
  {cantidadDeVidas: "3", user_id: "4"},
]

lives.each do |live|
  Life.create(live)
end

puts "se cagaron las vidas"