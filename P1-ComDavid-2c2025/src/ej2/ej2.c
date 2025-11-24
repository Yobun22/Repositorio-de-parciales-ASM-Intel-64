#include "../ejs.h"

bool son_iguales(producto_t *prod1, producto_t *prod2)
{
   return strcmp(prod1->nombre, prod2->nombre) == 0 && prod1->usuario->id == prod2->usuario->id;
}

catalogo_t *removerCopias(catalogo_t *h)
{
   publicacion_t *actual = h->first;
   while (actual != NULL)
   {
      publicacion_t *prev = actual;
      publicacion_t *runner = actual->next;
      while (runner != NULL)
      {
         if (son_iguales(actual->value, runner->value))
         {
            prev->next = runner->next;
            publicacion_t *borrar = runner;
            runner = runner->next;
            free(borrar->value);
            free(borrar);
         }
         else
         {
            prev = prev->next;
            runner = runner->next;
         }
      }
      actual = actual->next;
   }
   return h;
}
