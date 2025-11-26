extern malloc
extern calloc
extern strcpy

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

; tuit_t *publicar(char *mensaje, usuario_t *usuario);
global publicar
publicar:
    push rbp
    mov rbp, rsp
    
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; rbx = mensaje, r12 = user, r13 = nuevo_tuit
    ; r14 = user->seguidores
    mov rbx, rdi
    mov r12, rsi

    mov rdi, 1
    mov rsi, TUIT_SIZE
    call calloc
    mov r13, rax

    lea rdi, [r13 + TUIT_MENSAJE_OFFSET]
    mov rsi, rbx
    call strcpy

    mov edi, [r12 + USUARIO_ID_OFFSET]
    mov [r13 + TUIT_ID_AUTOR_OFFSET], edi

    mov rdi, r13
    mov rsi, [r12 + USUARIO_FEED_OFFSET]
    call agregarAFeed

    ; r14 = user->seguidores
    mov r14, [r12 + USUARIO_SEGUIDORES_OFFSET]

    ; r10 = i, r11 = user->cantSeguidores
    xor r10, r10

    mov r11D, [r12 + USUARIO_CANT_SEGUIDORES_OFFSET]
    .loop:
        cmp r10D, r11D
        jge .epilogo

        mov rdx, [r14 + r10*8]
        mov rdx, [rdx + USUARIO_FEED_OFFSET]

        test rdx, rdx
        jz .finloop

        mov rdi, r13
        mov rsi, rdx

        push r10
        push r11
        call agregarAFeed
        pop r11
        pop r10

    .finloop:
        inc r10
        jmp .loop

    .epilogo:
        mov rax, r13

        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret

agregarAFeed:
    push rbp
    mov rbp, rsp

    push rbx
    push r12

    ; rbx = nuevo_tuit, r12 = feed
    mov rbx, rdi
    mov r12, rsi

    mov rdi, PUBLICACION_SIZE
    call malloc

    ; rax = nueva_publicacion
    mov [rax + PUBLICACION_VALUE_OFFSET], rbx

    mov rdi, [r12 + FEED_FIRST_OFFSET]
    mov [rax + PUBLICACION_NEXT_OFFSET], rdi

    mov [r12 + FEED_FIRST_OFFSET], rax 

    .epilogo:
        pop r12
        pop rbx
        pop rbp
        ret
