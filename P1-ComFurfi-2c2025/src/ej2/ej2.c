#include "../ejs.h"

void borrarPublicacionesDe(feed_t *feed, usuario_t *usuario)
{
  publicacion_t *actual = feed->first;
  publicacion_t a_borrar;
  while (actual != NULL)
  {
  }
}

void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear)
{
  usuario->bloqueados[usuario->cantBloqueados] = usuarioABloquear;
  usuario->bloqueados += 1;

  return;
}
