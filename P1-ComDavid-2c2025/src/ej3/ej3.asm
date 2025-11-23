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

;usuario_t **asignarNivelesParaNuevosUsuarios(uint32_t *ids, uint32_t cantidadDeIds, uint8_t (*deQueNivelEs)(uint32_t)) {
global asignarNivelesParaNuevosUsuarios 
asignarNivelesParaNuevosUsuarios:
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    ; if cantidadIds es 0
    test esi, esi
    jz .null

    ; rbx = ids, r12D = cantidadDeIds, r13 = deQueNivelEs
    ; r14 = res, r15 = nuevo
    mov rbx, rdi
    mov r12D, esi
    mov r13, rdx

    lea rdi, [r12 * 8]
    call malloc
    mov r14, rax

    ; r10 = i
    xor r10, r10
    .loop:
        cmp r10D, r12D
        jge .notnull

        ; pido memoria a malloc para el nuevo
        mov rdi, USUARIO_SIZE
        push r10
        sub rsp, 8
        call malloc
        add rsp, 8
        pop r10

        ; r15 = nuevo
        mov r15, rax

        ; edi = ids[i]
        mov edi, [rbx + r10*4]
        mov [r15 + USUARIO_ID_OFFSET], edi


        push r10
        push rdi
        call r13
        pop rdi
        pop r10
        mov [r15 + USUARIO_NIVEL_OFFSET], al

        mov [r14 + r10*8], r15

        inc r10
        jmp .loop

    .notnull:
        mov rax, r14
        jmp .epilogo
    
    .null:
        xor rax, rax

    .epilogo:
        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret
