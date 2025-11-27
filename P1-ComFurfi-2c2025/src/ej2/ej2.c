#include "../ejs.h"

void borrarPublicacionesDe(feed_t *feed, usuario_t *usuario)
{
  publicacion_t **indirect = &(feed->first);
  publicacion_t *actual;
  uint32_t id_user = usuario->id;
  while (*indirect != NULL)
  {
    actual = *indirect;
    if (actual->value->id_autor == id_user)
    {
      *indirect = actual->next;
      free(actual);
    }
    else
      indirect = &(actual->next);
  }
}

void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear)
{
  usuario->bloqueados[usuario->cantBloqueados] = usuarioABloquear;
  usuario->cantBloqueados++;
  borrarPublicacionesDe(usuario->feed, usuarioABloquear);
  borrarPublicacionesDe(usuarioABloquear->feed, usuario);
  return;
}
