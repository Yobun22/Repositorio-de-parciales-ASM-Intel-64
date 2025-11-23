#include "../ejs.h"

bool esNuevoYVerificado(producto_t *producto_actual)
{
    return (producto_actual->estado == 1 && producto_actual->usuario->nivel > 0);
}

producto_t *filtrarPublicacionesNuevasDeUsuariosVerificados(catalogo_t *h)
{
    size_t cant = 0;
    publicacion_t *actual = h->first;
    while (actual != NULL)
    {
        if (esNuevoYVerificado(actual->value))
            cant++;
        actual = actual->next;
    }
    actual = h->first;
    producto_t **res = malloc((cant + 1) * 8);
    uint64_t i = 0;
    while (actual != NULL)
    {
        if (esNuevoYVerificado(actual->value))
            res[i++] = actual->value;
        actual = actual->next;
    }
    res[i] = NULL;
    return (producto_t *)res;
}
