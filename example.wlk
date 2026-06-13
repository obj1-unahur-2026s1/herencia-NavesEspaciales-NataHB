class Nave{
  var velocidad
  var direccion 
  var combustible

  method acelerar(cuanto) {velocidad = 100000.min(velocidad + cuanto)}
  method desacelerar(cuanto) {velocidad = 0.max(velocidad - cuanto)}

  method irHaciaELSol() {direccion = 10}
  method escaparDelSol() {direccion = -10}
  method ponerseParaleloAlSol() {direccion = 0}

  method acercarseUnPocoAlSol() {direccion = 10.min(direccion + 1)}
  method alejarseUnPocoDelSol() {direccion = -10.max(direccion - 1)}

  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method cargarCombustible(cuanto) {combustible += cuanto}
  method descargarCombustible(cuanto) {combustible -= cuanto}

  method estaTranquila() = combustible >= 4000 && velocidad <= 12000

  method escapar()
  method avisar()

  method reaccionarAnteAmenaza() {
    self.escapar()
    self.avisar()
  }

  method tienePocaActividad() 

  method estaRelajado() = self.estaTranquila() && self.tienePocaActividad()
}

class NaveBaliza inherits Nave{
  const colores = []
  var color
  method mostrarBaliza() = color
  method cambiarColorDeBaliza(colorNuevo) {color = colorNuevo; colores.add(colorNuevo)}

  override method estaTranquila() = super() && color != "rojo"

  override method prepararViaje() {
    super();
    self.cambiarColorDeBaliza("verde");
    self.ponerseParaleloAlSol()
  } 

  override method escapar(){
    self.irHaciaELSol()
  }
  override method avisar(){
    self.cambiarColorDeBaliza("rojo")
  }

  override method tienePocaActividad() = colores.isEmpty() 

}

class NaveDePasajeros inherits Nave{
  const cantidadPasajeros
  var cantidadRacionesDeComida
  var cantidadRacionesDeBebida

  var cantidadDeRacionesServidas

  method cargarComida(cantidadComida) {
    cantidadRacionesDeComida += cantidadComida
  }
  method descargarComida(cantidadComida) {
    cantidadRacionesDeComida -= cantidadComida;
    cantidadDeRacionesServidas += cantidadComida
  }


  method cargarBebida(cantidadBebida) {
    cantidadRacionesDeBebida += cantidadBebida
  }
  method descargarBebida(cantidadBebida) {
    cantidadRacionesDeBebida -= cantidadBebida
  }

  override method prepararViaje() {
    super();
    self.cargarComida(4*cantidadPasajeros);
    self.cargarBebida(6*cantidadPasajeros);
    self.acercarseUnPocoAlSol()
  } 

  override method escapar(){
    self.acelerar(velocidad)
  }
  override method avisar(){
    self.descargarComida(cantidadPasajeros)
    self.descargarBebida(cantidadPasajeros*2)
  }

  override method tienePocaActividad() = cantidadDeRacionesServidas < 50

  /*
  method cargar(elemento, cantidad){
    elemento += cantidad
  }
  */
}

class NaveCombate inherits Nave{
  const mensajesEmitidos = []
  var estaVisible
  var misilesDesplegados

  override method estaTranquila() = super() && !misilesDesplegados 

  method estaInvisible() = !estaVisible 
  method ponerseVisible() {estaVisible = true}
  method ponerseInvisible() {estaVisible = false}

  method misilesDesplegados() = misilesDesplegados
  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}

  method mensajesEmitidos() = mensajesEmitidos
  method emitirMensaje(mensaje) {mensajesEmitidos.add(mensaje)}
  method primerMensajeEmitido() = mensajesEmitidos.first()
  method ultimoMensajeEmitido() = mensajesEmitidos.last()
  method esEscueta() = !mensajesEmitidos.any({m=>m.size() > 30})
  method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

  override method prepararViaje() {
    super();
    self.ponerseVisible();
    self.replegarMisiles();
    self.acelerar(15000);
    self.emitirMensaje("Saliendo en misión")
  }

  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar(){
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveHospital inherits NaveDePasajeros{
  var tieneQuirofanosPreparados 
  method tieneQuirofanosPreparados() = tieneQuirofanosPreparados
  method prepararQuirofano() {tieneQuirofanosPreparados = true}

  override method estaTranquila() = super() && tieneQuirofanosPreparados 
  override method reaccionarAnteAmenaza() {
    super();
    self.prepararQuirofano()
  }
}

class NaveDeCombateSigilosa inherits NaveCombate{
  override method estaTranquila() = super() && self.estaInvisible()
  override method reaccionarAnteAmenaza() {
    super();
    self.desplegarMisiles()
    self.ponerseInvisible()
  }

}