#include "../ejs.h"
#include <stdint.h>

usuario_t **asignarNivelesParaNuevosUsuarios(uint32_t *ids, uint32_t cantidadDeIds,
                                             uint8_t (*deQueNivelEs)(uint32_t))
{
  if (cantidadDeIds == 0)
    return NULL;
  usuario_t **res = malloc(cantidadDeIds * 8);

  for (uint32_t i = 0; i < cantidadDeIds; i++)
  {
    usuario_t *nuevo = malloc(sizeof(usuario_t));
    nuevo->id = ids[i];
    nuevo->nivel = deQueNivelEs(ids[i]);
    res[i] = nuevo;
  }
  return res;
}
