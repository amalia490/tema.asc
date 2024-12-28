.data
    b: .space 4096
    nr_comenzi: .space 4
    scanare: .asciz "%d\n"
    afisare_fis: .asciz "%d: (%d, %d)\n"
    afisare_zero: .asciz "%d: (0, 0)\n"
    ecx_copy: .space 4
    ecx_copy2: .space 4
    nume_comanda: .space 4

    afisare.get: .asciz "(%d, %d)\n"
    afisarezero: .asciz "(0, 0)\n"

    afisare.delete: .asciz "%d: (%d, %d)\n"

    afisare4: .asciz "%d: (%d, %d)\n"

.text

add3:

    lea 16(%ebp), %eax
    push %eax
    push $scanare
    call scanf
    add $8, %esp
    
    xor %ecx, %ecx

    et_for1:
        mov 16(%ebp), %eax
        cmp %eax, %ecx
        jge et_exit
        mov %ecx, ecx_copy

        lea 12(%ebp), %eax
        push %eax
        push $scanare
        call scanf
        add $8, %esp

        lea 8(%ebp), %eax
        push %eax
        push $scanare
        call scanf
        add $8, %esp

        mov 8(%ebp), %eax
        xor %edx, %edx
        mov $8, %ebx
        div %ebx
        cmp $0, %edx
        je continuare

        add $1, %eax

    continuare:
        mov %eax, 4(%ebp)
        movl $0, -4(%ebp)        
        movl $1, -12(%ebp)

    et_ok: 
        mov -12(%ebp), %eax
        cmp $0, %eax
        je et_for1
        mov -4(%ebp), %edx
        cmp $1024, %edx
        jge exit2
        mov %edx, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $0, %esi
        je continuare3
        jmp et_i 

    continuare3: 
        mov -4(%ebp), %eax
        mov %eax, -8(%ebp)
    et_for2:
        mov -8(%ebp), %eax
        cmp $1024, %eax
        jge exit2
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $0, %esi
        je continuare4
        jmp et_i
    continuare4:
        mov -8(%ebp), %eax
        sub -4(%ebp), %eax
        incl %eax
        cmp 4(%ebp), %eax
        je adaugare

        incl -8(%ebp)
        jmp et_for2

    adaugare: 
        mov -4(%ebp), %eax
        mov %eax, -16(%ebp)
    et_for3:
        mov -16(%ebp), %eax
        cmp -8(%ebp), %eax
        jg alocare
        mov %eax, %ebx
        mov 12(%ebp), %esi
        mov %esi, (%edi, %ebx, 4)
        incl -16(%ebp)
        jmp et_for3
    alocare:
        push -8(%ebp)
        push -4(%ebp)
        push 12(%ebp)
        push $afisare_fis
        call printf
        add $16, %esp

        pushl $0
        call fflush
        popl %eax
        movl $0, -12(%ebp)
        jmp exit1

    et_i: 
        incl -4(%ebp)
        jmp et_ok
    exit2:
        push 12(%ebp)
        push $afisare_zero
        call printf
        add $8, %esp

        pushl $0
        call fflush
        popl %eax
        
        movl $0, -12(%ebp)
    exit1:
        mov ecx_copy, %ecx
        inc %ecx
        jmp et_for1
    et_exit:
         ret

get3:
    lea -8(%ebp), %eax
    push %eax
    push $scanare
    call scanf
    add $8, %esp
    xor %ecx, %ecx
    movl $0, -4(%ebp)

    et_get1:
        mov -4(%ebp), %eax
        cmp $1024, %eax
        jge exitt
    et_get2:
        mov -8(%ebp), %ecx
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp %esi, %ecx
        jne et_get3
        mov -4(%ebp), %eax
        mov %eax, 4(%ebp)
    et_get4:
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp %esi, -8(%ebp)
        jne afisarre
        incl 4(%ebp)
        mov 4(%ebp), %eax
        jmp et_get4
    afisarre:
        sub $1, 4(%ebp)
        push 4(%ebp)
        push -4(%ebp)
        push $afisare.get
        call printf
        add $12, %esp

        pushl $0
        call fflush
        popl %eax
        jmp exitt2
    et_get3:
        incl -4(%ebp)
        jmp et_get1
    exitt:
        push $afisarezero
        call printf
        add $4, %esp

        pushl $0
        call fflush
        popl %eax
    exitt2:
        ret

delete3:
    lea 12(%ebp), %eax
    push %eax
    push $scanare
    call scanf
    add $8, %esp
    movl $0, 4(%ebp)

    delete1: 
        mov 4(%ebp), %eax
        cmp $1024, %eax
        jge exittt

    delete2:
        mov 12(%ebp), %ecx
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp %esi, %ecx
        jne deletee3

        mov 4(%ebp), %eax
        mov %eax, 8(%ebp)

    delete4:
        mov 8(%ebp), %ebx
        mov (%edi, %ebx, 4), %esi
        cmp %esi, 12(%ebp)
        jne delete5
        movl $0, (%edi, %ebx, 4)
        incl 8(%ebp)
        jmp delete4

    deletee3:
        mov %eax, 8(%ebp)
        incl 8(%ebp)
        cmp $0, %esi
        je delete5
    del3: 
        mov 8(%ebp), %ebx
        mov (%edi, %ebx, 4), %eax
        cmp %esi, %eax
        jne afisaree
        cmp $1024, %ebx
        jge afisaree
        incl 8(%ebp)
        jmp del3
    delete5:
        mov 8(%ebp), %eax
        mov %eax, 4(%ebp)
        jmp delete1
    
    afisaree:
        mov 4(%ebp), %eax
        sub $1, 8(%ebp)
        push 8(%ebp)
        push 4(%ebp)
        push %esi
        push $afisare.delete
        call printf
        add $16, %esp
    break0:
        pushl $0
        call fflush
        popl %eax
        incl 8(%ebp)
        jmp delete5
    exittt:
        ret

defr3:
    movl $0, 4(%ebp)	
	mov 4(%ebp), %eax
    defr0:
        mov 4(%ebp), %eax
        cmp $1024, %eax
        jge afisare
        
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $0, %esi
        jne et_defr3
        
        mov %eax, 8(%ebp)
        incl 8(%ebp)
    defr1:
        mov 8(%ebp), %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $1024, %ebx
        jge afisare
        cmp $0, %esi
        jne alocaree
        incl 8(%ebp)
        jmp defr1

    alocaree: 	
        mov 4(%ebp), %ebx
        mov %esi, (%edi, %ebx, 4)
        mov 8(%ebp), %eax
        movl $0, (%edi, %eax, 4)
        jmp et_defr3
    et_defr3: 
        incl 4(%ebp)
        jmp defr0
    afisare:
        movl $0, 4(%ebp)
    afisare1:
        mov 4(%ebp), %eax
        cmp $1024, %eax
        jge exiit
        mov %eax, 8(%ebp)
        mov (%edi, %eax, 4), %esi
        incl 8(%ebp)
        cmp $0, %esi
        je exiit
    afisaree1:
        mov 8(%ebp), %ebx
        mov (%edi, %ebx, 4), %edx
        cmp %esi, %edx
        jne afisare2
        incl 8(%ebp)
        jmp afisaree1
    afisare2:
        sub $1, 8(%ebp)
        push 8(%ebp)
        push 4(%ebp)
        push %esi
        push $afisare4
        call printf
        add $16, %esp

        pushl $0
        call fflush
        popl %eax
                
        incl 8(%ebp)
        mov 8(%ebp), %eax
        mov %eax, 4(%ebp)
        jmp afisare1
    exiit:
        ret

.global main
main:

    lea b, %edi
    push $nr_comenzi
    push $scanare
    call scanf
    add $8, %esp
    xor %ecx, %ecx
inceput:
    cmp nr_comenzi, %ecx
    jge iesire

    mov %ecx, ecx_copy2

    push $nume_comanda
    push $scanare
    call scanf
    add $8, %esp

    mov nume_comanda, %edx
    cmp $1, %edx
    je add
    jmp var2
add:
    push %ebp
    mov %esp, %ebp
    sub $20, %esp
    call add3
    add $40, %esp
    jmp adaug
var2:
    cmp $2, %edx
    je get
    jmp var3
get:
    push %ebp
    mov %esp, %ebp
    sub $8, %esp
    call get3
    add $20, %esp
    jmp adaug
var3:
    cmp $3, %edx
    je delete
    jmp var4
delete:
    push %ebp
    mov %esp, %ebp
    sub $16, %esp
    call delete3
    add $16, %esp
    jmp adaug
var4:
    cmp $4, %edx
    je defr

defr:
    push %ebp
    mov %esp, %ebp
    sub $16, %esp
    call defr3
    add $16, %esp
    jmp adaug
    
adaug:
    incl ecx_copy2
    mov ecx_copy2, %ecx
    jmp inceput

iesire:

    mov $1, %eax
    mov $0, %ebx
    int $0x80
