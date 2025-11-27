extern malloc

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

; tuit_t **trendingTopic(usuario_t *usuario, uint8_t (*esTuitSobresaliente)(tuit_t *));
global trendingTopic 
trendingTopic:
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; dejo rax = NULL
    xor rax, rax

    ; rbx = user, r12 = esTuitSobresaliente, r13 = cant, r14 = actual
    mov rbx, rdi
    mov r12, rsi
    xor r13, r13

    mov r14, [rbx + USUARIO_FEED_OFFSET]
    mov r14, [r14 + FEED_FIRST_OFFSET]

    .loopcant:
        test r14, r14
        jz .finloopcant

        ; r15 = actual->value
        mov r15, [r14 + PUBLICACION_VALUE_OFFSET]
        mov rdi, r15
        call r12

        test rax, rax
        jz .itloopcant

        mov edi, [r15 + TUIT_ID_AUTOR_OFFSET]
        mov esi, [rbx + USUARIO_ID_OFFSET]
        cmp edi, esi
        jne .itloopcant

        inc r13
    
    .itloopcant:
        mov r14, [r14 + PUBLICACION_NEXT_OFFSET]
        jmp .loopcant

    .finloopcant:
        test r13, r13
        jz .null

        mov rdi, TUIT_SIZE
        imul rdi, r13
        inc rdi
        call malloc

        ; r15 = sobresalientes
        mov r15, rax 
        
        mov r14, [rbx + USUARIO_FEED_OFFSET]
        mov r14, [r14 + FEED_FIRST_OFFSET]

        ; r10 = i, r11 = actual->value
        xor r10, r10
    .loopsobresalientes:
        test r14, r14
        jz .notnull

        ; r11 = actual->value
        mov r11, [r14 + PUBLICACION_VALUE_OFFSET]
        mov rdi, r11

        push r10
        push r11
        call r12
        pop r11
        pop r10

        test rax, rax
        jz .itloopsobresalientes

        mov edi, [r11 + TUIT_ID_AUTOR_OFFSET]
        mov esi, [rbx + USUARIO_ID_OFFSET]
        cmp edi, esi
        jne .itloopsobresalientes

        mov [r15 + r10*8], r11
        inc r10
    
    .itloopsobresalientes:
        mov r14, [r14 + PUBLICACION_NEXT_OFFSET]
        jmp .loopsobresalientes

    .null:
        xor rax, rax
        jmp .epilogo

    .notnull:
        mov QWORD [r15 + r10*8], 0
        mov rax, r15

    .epilogo:
        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret




