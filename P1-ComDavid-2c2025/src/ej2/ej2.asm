;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

extern free
extern strcmp
; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

PRODUCTO_USUARIO_OFFSET EQU 0
PRODUCTO_CATEGORIA_OFFSET EQU 8
PRODUCTO_NOMBRE_OFFSET EQU 17
PRODUCTO_ESTADO_OFFSET EQU 42
PRODUCTO_PRECIO_OFFSET EQU 44
PRODUCTO_ID_OFFSET EQU 48
PRODUCTO_SIZE EQU 56

PUBLICACION_NEXT_OFFSET EQU 0
PUBLICACION_VALUE_OFFSET EQU 8
PUBLICACION_SIZE EQU 16

CATALOGO_FIRST_OFFSET EQU 0
CATALOGO_SIZE EQU 8

;catalogo* removerCopias(catalogo* h)
global removerCopias
removerCopias:
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; rbx = h, r12 = actual, r13 = prev, r14 = runner
    mov rbx, rdi
    mov r12, [rbx + CATALOGO_FIRST_OFFSET]
    
    .looppiv:
        test r12, r12
        jz .epilogo

        mov r13, r12
        mov r14, [r12 + PUBLICACION_NEXT_OFFSET]
    .looprun:
        ; runner == NULL??
        test r14, r14
        jz .finpiv

        ; aca va el chequeo de si son iguales
        ; rdi = actual->value->nombre, rsi = runner->value->nombre
        mov rdi, [r14 + PUBLICACION_VALUE_OFFSET]
        push rdi
        lea rdi, [rdi + PRODUCTO_NOMBRE_OFFSET]

        mov rsi, [r12 + PUBLICACION_VALUE_OFFSET]
        push rsi
        lea rsi, [rsi + PRODUCTO_NOMBRE_OFFSET]

        call strcmp
        pop rsi
        pop rdi
        
        test rax, rax
        jnz .else
        ; rdi = actual->value->usuario->id, rsi = runner->value->usuario->id
        mov rdi, [rdi + PRODUCTO_USUARIO_OFFSET]
        mov edi, [rdi + USUARIO_ID_OFFSET]

        mov rsi, [rsi + PRODUCTO_USUARIO_OFFSET]
        mov esi, [rsi + USUARIO_ID_OFFSET]

        cmp edi, esi
        jne .else

        ; ahora ya se que son iguales

        ; prev->next = runner->next
        mov rdi, [r14 + PUBLICACION_NEXT_OFFSET]
        mov [r13 + PUBLICACION_NEXT_OFFSET], rdi

        ; r15 = borrar
        mov r15, r14

        ; runner = runner->next
        mov rdi, [r14 + PUBLICACION_NEXT_OFFSET]
        mov r14, rdi

        mov rdi, [r15 + PUBLICACION_VALUE_OFFSET]
        call free

        mov rdi, r15
        call free

        jmp .finrun
    .else:
        mov rdi, [r13 + PUBLICACION_NEXT_OFFSET]
        mov r13, rdi

        mov rdi, [r14 + PUBLICACION_NEXT_OFFSET]
        mov r14, rdi

    .finrun:
        jmp .looprun

    .finpiv:
        mov r12, [r12 + PUBLICACION_NEXT_OFFSET]
        jmp .looppiv

    .epilogo:
        mov rax, rbx
        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret
