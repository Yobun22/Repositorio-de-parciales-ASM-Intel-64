extern free

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
TUIT_MENSAJE_OFFSET EQU 0
TUIT_FAVORITOS_OFFSET EQU 140
TUIT_RETUITS_OFFSET EQU 142
TUIT_ID_AUTOR_OFFSET EQU 144
TUIT_SIZE EQU 148

PUBLICACION_NEXT_OFFSET EQU 0
PUBLICACION_VALUE_OFFSET EQU 8
PUBLICACION_SIZE EQU 16

FEED_FIRST_OFFSET EQU 0 
FEED_SIZE EQU 8

USUARIO_FEED_OFFSET EQU 0;
USUARIO_SEGUIDORES_OFFSET EQU 8; 
USUARIO_CANT_SEGUIDORES_OFFSET EQU 16; 
USUARIO_SEGUIDOS_OFFSET EQU 24; 
USUARIO_CANT_SEGUIDOS_OFFSET EQU 32; 
USUARIO_BLOQUEADOS_OFFSET EQU 40; 
USUARIO_CANT_BLOQUEADOS_OFFSET EQU 48; 
USUARIO_ID_OFFSET EQU 52; 
USUARIO_SIZE EQU 56

; void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear);
global bloquearUsuario 
bloquearUsuario:
    push rbp
    mov rbp, rsp
    
    push rbx
    push r12

    mov rbx, rdi
    mov r12, rsi

    mov edi, [rbx + USUARIO_CANT_BLOQUEADOS_OFFSET]
    mov rsi, [rbx + USUARIO_BLOQUEADOS_OFFSET]

    mov [rsi + rdi*8], r12

    inc DWORD [rbx + USUARIO_CANT_BLOQUEADOS_OFFSET]

    mov rdi, [rbx + USUARIO_FEED_OFFSET]
    mov rsi, r12
    call borrarPublicacionesDe

    mov rdi, [r12 + USUARIO_FEED_OFFSET]
    mov rsi, rbx
    call borrarPublicacionesDe

    .epilogo:
        pop r12
        pop rbx
        pop rbp
        ret

borrarPublicacionesDe:
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; rbx = indirect, r12 = usuario->id, r13 = actual
    lea rbx, [rdi + FEED_FIRST_OFFSET]
    mov r12D, [rsi + USUARIO_ID_OFFSET]

    .loop:
        ; r13 = actual
        mov r13, [rbx]
        test r13, r13
        jz .epilogo

        mov rsi, [r13 + PUBLICACION_VALUE_OFFSET]
        mov esi, [rsi + TUIT_ID_AUTOR_OFFSET]
        cmp esi, r12D
        jne .else

        mov rsi, [r13 + PUBLICACION_NEXT_OFFSET]
        mov [rbx], rsi

        mov rdi, r13
        call free
        jmp .loop

    .else:
        lea rbx, [r13 + PUBLICACION_NEXT_OFFSET]
        jmp .loop

    .epilogo:
        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret

