#include "../ejs.h"
#include <string.h>

void agregarAFeed(tuit_t *nuevo_tuit, feed_t *feed)
{
  publicacion_t *nueva_publicacion = malloc(sizeof(publicacion_t));
  nueva_publicacion->value = nuevo_tuit;
  nueva_publicacion->next = feed->first;
  feed->first = nueva_publicacion;
}

// Función principal: publicar un tuit
tuit_t *publicar(char *mensaje, usuario_t *user)
{
  tuit_t *nuevo_tuit = calloc(1, sizeof(tuit_t));
  strcpy(nuevo_tuit->mensaje, mensaje);
  nuevo_tuit->id_autor = user->id;
  agregarAFeed(nuevo_tuit, user->feed);
  usuario_t *actual;
  for (uint16_t i = 0; i < user->cantSeguidores; i++)
  {
    if (user->seguidores[i]->feed == NULL)
      continue;
    agregarAFeed(nuevo_tuit, user->seguidores[i]->feed);
  }
  return nuevo_tuit;
}
