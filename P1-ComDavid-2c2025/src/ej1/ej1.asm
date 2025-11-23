;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

extern malloc
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


;producto_t* filtrarPublicacionesNuevasDeUsuariosVerificados (catalogo*)
global filtrarPublicacionesNuevasDeUsuariosVerificados
filtrarPublicacionesNuevasDeUsuariosVerificados:
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; rbx = *h, r12 = h->first
    mov rbx, rdi
    ; rdi = actual = r12 = h->first
    mov rdi, [rbx + CATALOGO_FIRST_OFFSET]
    mov r12, rdi
    call contarNuevosYVerificados

    ; rdi = cant
    mov rdi, rax
    inc rdi
    imul rdi, 8
    call malloc

    ; r13 = **res, rdi = actual = h->first, r11 = i
    mov r13, rax 
    mov rdi, r12
    xor r11, r11
    
    xor r10, r10
    .loop:
        test rdi, rdi
        jz .fin

        ; rdx = actual->value
        mov rdx, [rdi + PUBLICACION_VALUE_OFFSET]

        ; r10 = publicacion_actual->estado
        mov r10W, [rdx + PRODUCTO_ESTADO_OFFSET]

        cmp r10W, 1
        jne .prox

        xor r10, r10
        ; r10 = publicacion_actual->estado->usuario
        mov r10, [rdx + PRODUCTO_USUARIO_OFFSET]
        mov r10B, [r10 + USUARIO_NIVEL_OFFSET]
        cmp r10B, 0
        jle .prox

        mov [r13 + r11*8], rdx
        inc r11

        .prox:
            mov rdi, [rdi + PUBLICACION_NEXT_OFFSET]
            jmp .loop

    .fin:
        mov QWORD [r13 + r11*8], 0
        mov rax, r13
    .epilogo:
        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret

contarNuevosYVerificados:
    push rbp
    mov rbp, rsp

    ; rax = cant, rdi = actual, rdx = actual->value
    xor rax, rax
    xor r10, r10
    .loopContar:
        test rdi, rdi
        jz .epilogo

        ; rdx = actual->value
        mov rdx, [rdi + PUBLICACION_VALUE_OFFSET]

        ; r10W = publicacion_actual->estado
        mov r10W, [rdx + PRODUCTO_ESTADO_OFFSET]

        cmp r10W, 1
        jne .proxItLoopContar

        xor r10, r10
        ; r10 = publicacion_actual->estado->usuario
        mov r10, [rdx + PRODUCTO_USUARIO_OFFSET]
        mov r10B, [r10 + USUARIO_NIVEL_OFFSET]
        cmp r10B, 0
        jle .proxItLoopContar

        inc rax

        .proxItLoopContar:
            mov rdi, [rdi + PUBLICACION_NEXT_OFFSET]
            jmp .loopContar

    .epilogo:
        pop rbp
        ret


