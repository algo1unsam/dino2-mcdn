import wollok.game.*

const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.boardGround("fondo.png")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino1)
		game.addVisual(dino2)
		game.addVisual(reloj)
		reloj.iniciar()
	
		keyboard.space().onPressDo{ self.jugar()}
		game.onCollideDo(dino1,{ obstaculo => 
		obstaculo.chocar()
		reloj.detener()
		})
    game.onCollideDo(dino2,{ obstaculo => 
		obstaculo.chocar()
		reloj.detener()
		})
		
	} 
	
	method iniciar(){
		dino1.iniciar()
		dino2.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino1.estaVivo()) {
      dino1.saltar()
      dino2.saltar()
		} else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar() {
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino1.morir()
		dino2.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
}

object reloj {
	var property tiempo = 0 
	method text() = tiempo.toString()
  	//method textColor() = "00FF00FF"
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo + 10
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent('tiempo')
	}
}

object cactus {
	var property position = self.posicionInicial()

	method image() = "cactus.png"
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = self.position().left(1)
	}
	
	method chocar(){
		if(self.position() == dino1.position()) juego.terminar()
		if(self.position() == dino2.position()) juego.terminar()
	}

  method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{

	method position() = game.origin().up(1)
	method image() = "suelo.png"
}


class Dino {
	var vivo = true
	var inAir = false
	var property position
	
	method image() = "dino.png"
	
	method saltar(){
		if (self.estaEnSuelo()  && !inAir){
      inAir = true
			self.subir()
			game.schedule(700, {self.bajar()})
			game.schedule(750, {inAir = false})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}

	method estaEnSuelo() = suelo.position().y() == self.position().y()
	
}

const dino1 = new Dino(position = game.at(1,suelo.position().y()))
const dino2 = new Dino(position = game.at(5,suelo.position().y()))
