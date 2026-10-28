# Pruebas

En Xcode, selecciona el esquema compartido `TicTacToe-Game` y un simulador de iPhone; ejecuta Product → Test (⌘U).

- `BoardLogicServiceTests`: las ocho líneas ganadoras para X/O, empate, tablero vacío, coordenadas inválidas, casillas ocupadas y partidas finalizadas.
- `GameViewModelTests`: cancelación al reiniciar/salir, bloqueo del turno del bot, resultado inmediato, presentación diferida, animación de victoria y reinicio completo durante la animación.

`ManualDelay` reemplaza la espera real por una suspensión controlada. La prueba libera explícitamente cada espera; incluso una tarea cancelada puede reanudarse, comprobando que no modifica una ronda posterior. `Task.yield()` permite que las tareas del actor principal avancen sin esperar los tiempos de animación reales.

El resultado lógico y el marcador se actualizan al detectar la victoria o empate. La hoja se muestra al finalizar la animación. Reiniciar una ronda conserva el marcador; el reinicio completo lo borra.

Estas pruebas no cubren todavía la estrategia del bot, VoiceOver ni la presentación visual en dispositivos.
