#include "../ejs.h"

void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear){
  usuario->bloqueados[usuario->cantBloqueados] = usuarioABloquear;
  usuario->bloqueados += 1;
  
  return;
}
