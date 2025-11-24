#include "../ejs.h"


catalogo_t *removerCopias(catalogo_t *h)
{
   publicacion_t *actual = h->first;
   while (actual != NULL && actual->next != NULL)
   {
      
      actual = actual->next;
   }
   return h;
}
