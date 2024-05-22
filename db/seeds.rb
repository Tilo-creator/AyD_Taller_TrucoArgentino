require './app'
users = [
  { names: 'Jon Doe', username: 'jondoe', email: 'jon@doe.com', password: 'abc'},
  { names: 'Jane Doe', username: 'janedoe', email: 'jane@doe.com', password: 'abc'},
  { names: 'Baby Doe', username: 'babydoe', email: 'baby@doe.com', password: 'abc'},
]

users.each do |u|
  User.create(u)
end

lessons_data = [ 
  {title:"Tipo de Mazo", description: "El truco se juega con un mazo español de 40 cartas, excluyendo los ochos y nueves. Este mazo está compuesto por cuatro palos: oros, copas, espadas y bastos. Cada palo tiene cartas numeradas del 1 al 7 y las figuras que son el 10 (sota), 11 (caballo) y 12 (rey). El mazo español es tradicional en muchos juegos de cartas en España y América Latina, y su uso en el truco es una característica distintiva del juego.", chapter: "Con qué tipo de mazo se juega y con qué cartas del mismo" },
  {title: "Cartas del Mazo", content: "Las cartas del mazo español incluyen oros, copas, espadas y bastos, con valores del 1 al 7 y 10 a 12. En el truco, las figuras (10, 11 y 12) no tienen el mismo valor numérico que en otros juegos, ya que el 10, 11 y 12 corresponden a sota, caballo y rey respectivamente. Este sistema de numeración es importante para entender cómo se juega y se puntúa en el truco.", chapter: "Con qué tipo de mazo se juega y con qué cartas del mismo"}
]
lessons_data.each do |lesson|
  Lesson.create(lesson)
end

