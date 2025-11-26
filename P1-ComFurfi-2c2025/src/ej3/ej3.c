#include "../ejs.h"

tuit_t **trendingTopic(usuario_t *user,
                       uint8_t (*esTuitSobresaliente)(tuit_t *))
{

    size_t cant = 0;
    publicacion_t *actual = user->feed->first;
    while (actual != NULL)
    {
        if (esTuitSobresaliente(actual->value) && actual->value->id_autor == user->id)
            cant++;
        actual = actual->next;
    }
    if (cant == 0)
        return NULL;
    tuit_t **sobresalientes = malloc(sizeof(tuit_t) * cant + 1);
    actual = user->feed->first;
    uint64_t i = 0;
    while (actual != NULL)
    {
        if (esTuitSobresaliente(actual->value) && actual->value->id_autor == user->id)
        {
            sobresalientes[i] = actual->value;
            i++;
        }
        actual = actual->next;
    }

    sobresalientes[i] = NULL;
    return sobresalientes;
}
