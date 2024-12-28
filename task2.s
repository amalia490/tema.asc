.data
    b: .space 16777216
    nr_comenzi: .space 4
    scanare: .asciz "%d"
    afisare_fis: .asciz "%d: ((%d, %d), (%d, %d))\n"
    afisare_zero: .asciz "%d: ((0, 0), (0, 0))\n"
    ecx_copy: .space 4
    ecx_copy2: .space 4
    nume_comanda: .space 4
    afisare.get: .asciz "((%d, %d), (%d, %d))\n"
    afisarezero: .asciz "((0, 0), (0, 0))\n"
    descriptor: .space 4
    spatiu: .space 4
    i: .long 0
    poz: .long 0
    afisare.delete: .asciz "%d: ((%d, %d), (%d, %d))\n"

.text

matrice_add:

    lea 16(%ebp), %eax
    push %eax
    push $scanare
    call scanf
    add $8, %esp
    
    xor %ecx, %ecx

    et_for:
        cmp 16(%ebp), %ecx
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
		cmp $1024, %eax
		jg exit2
        mov %eax, 4(%ebp)
        movl $0, -4(%ebp)   
	et_for1:
		mov -4(%ebp), %eax
        cmp $1048576, %eax
        jge exit2
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $0, %esi
        je continuare2
        jmp et_i
	continuare2:
		mov -4(%ebp), %eax
        mov %eax, -8(%ebp)
	et_for2:
		mov -8(%ebp), %eax
        cmp $1048576, %eax
        jge exit2 
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $0, %esi
        je continuare3
        jmp et_i
    continuare3:
        mov -8(%ebp), %eax
        sub -4(%ebp), %eax
        incl %eax
        cmp 4(%ebp), %eax
        jge continuare4

        incl -8(%ebp)
        jmp et_for2
	continuare4:
		mov -4(%ebp), %eax
		xor %edx, %edx
		xor %ebx, %ebx
		add $1024, %ebx
		div %ebx
		mov %eax, 20(%ebp)
		mov %edx, 24(%ebp)
		xor %edx, %edx
		mov -8(%ebp), %eax
		div %ebx
		mov %eax, 28(%ebp)
		mov %edx, 32(%ebp)
		cmp 20(%ebp), %eax
		je adaugare
		jmp linie_noua
	adaugare: 
        mov -4(%ebp), %eax
        mov %eax, 36(%ebp)
    et_for3:
        mov 36(%ebp), %eax
        cmp -8(%ebp), %eax
        jg afisare
        mov %eax, %ebx
        mov 12(%ebp), %esi
        mov %esi, (%edi, %ebx, 4)
        incl 36(%ebp)
        jmp et_for3
	afisare:
		push 32(%ebp)
		push 28(%ebp)
        push 24(%ebp)
        push 20(%ebp)
        push 12(%ebp)
        push $afisare_fis
        call printf
        add $24, %esp

        pushl $0
        call fflush
        popl %eax
        jmp exit1
	linie_noua:
        mov $1024, %eax
        incl 20(%ebp)
        mull 20(%ebp)
        mov %eax, -4(%ebp)
        jmp et_for1
	et_i: 
        incl -4(%ebp)
        jmp et_for1
    exit2:
        push 12(%ebp)
        push $afisare_zero
        call printf
        add $8, %esp
        pushl $0
        call fflush
        popl %eax

        movl $0, 20(%ebp)
    exit1:
        mov ecx_copy, %ecx
        incl %ecx
        jmp et_for
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
        cmp $1048576, %eax
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
        cmp $1048576, %eax
        je afisaare
        cmp %esi, -8(%ebp)
        jne afisaare
        incl 4(%ebp)
        mov 4(%ebp), %eax
        jmp et_get4
    afisaare:
        mov -4(%ebp), %eax
		xor %edx, %edx
		xor %ebx, %ebx
		add $1024, %ebx
		div %ebx
		mov %eax, 8(%ebp)
		mov %edx, 12(%ebp)
		xor %edx, %edx
        sub $1, 4(%ebp)
		mov 4(%ebp), %eax
		div %ebx
		mov %eax, 16(%ebp)
		mov %edx, 20(%ebp)
        push 20(%ebp)
        push 16(%ebp)
        push 12(%ebp)
        push 8(%ebp)
        push $afisare.get
        call printf
        add $20, %esp

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

delete0:
    lea 12(%ebp), %eax
    push %eax
    push $scanare
    call scanf
    add $8, %esp
    movl $0, 4(%ebp)

    delete1: 
        mov 4(%ebp), %eax
        cmp $1048576, %eax
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
        cmp $1048576, %ebx
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
		xor %edx, %edx
		xor %ebx, %ebx
		add $1024, %ebx
		div %ebx
		mov %eax, 16(%ebp)
		mov %edx, 20(%ebp)
		xor %edx, %edx
		mov 8(%ebp), %eax
		div %ebx
		mov %eax, 24(%ebp)
		mov %edx, 28(%ebp)
        push 28(%ebp)
        push 24(%ebp)
        push 20(%ebp)
        push 16(%ebp)
        push %esi
        push $afisare.delete
        call printf
        add $24, %esp

        pushl $0
        call fflush
        popl %eax
    break0:
        incl 8(%ebp)
        jmp delete5
    exittt:
        ret

matrice_add2:

    mov descriptor, %eax
    mov %eax, 12(%ebp)
    mov spatiu, %eax
    mov %eax, 8(%ebp)

    mov poz, %eax
    mov %eax, 4(%ebp)   
	et_forr1:
		mov 4(%ebp), %eax
        cmp $1048576, %eax
        jge et_exxit
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $0, %esi
        je continuarre2
        jmp ett_i
	continuarre2:
		mov 4(%ebp), %eax
        mov %eax, 16(%ebp)
	et_forr2:
		mov 16(%ebp), %eax
        cmp $1048576, %eax
        jge et_exxit
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $0, %esi
        je continuarre3
        jmp ett_i
    continuarre3:
        mov 16(%ebp), %eax
        sub 4(%ebp), %eax
        incl %eax
        cmp 8(%ebp), %eax
        jge continuarre4

        incl 16(%ebp)
        jmp et_forr2
	continuarre4:
		mov 4(%ebp), %eax
		xor %edx, %edx
		xor %ebx, %ebx
		add $1024, %ebx
		div %ebx
		mov %eax, 20(%ebp)
		mov %edx, 24(%ebp)
		xor %edx, %edx
		mov 16(%ebp), %eax
		div %ebx
		mov %eax, 28(%ebp)
		mov %edx, 32(%ebp)
		cmp 20(%ebp), %eax
		je adaugarre
		jmp linie_nnoua
	adaugarre: 
        mov 4(%ebp), %eax
        mov %eax, 36(%ebp)
    et_forr3:
        mov 36(%ebp), %eax
        cmp 16(%ebp), %eax
        jg afissare
        mov %eax, %ebx
        mov 12(%ebp), %esi
        mov %esi, (%edi, %ebx, 4)
        incl 36(%ebp)
        jmp et_forr3
	afissare:
		push 32(%ebp)
		push 28(%ebp)
        push 24(%ebp)
        push 20(%ebp)
        push 12(%ebp)
        push $afisare_fis
        call printf
        add $24, %esp

        pushl $0
        call fflush
        popl %eax
        jmp et_exxit
	linie_nnoua:
        mov $1024, %eax
        incl 20(%ebp)
        mull 20(%ebp)
        mov %eax, 4(%ebp)
        jmp et_forr1
	ett_i: 
        incl 4(%ebp)
        jmp et_forr1
    et_exxit:
        mov 16(%ebp), %eax
        mov %eax, poz
        incl poz
        ret

dellete0:
    mov descriptor, %eax
    mov %eax, 12(%ebp)
    mov i, %eax
    mov %eax, 4(%ebp)

    mov 4(%ebp), %eax
    cmp $1048576, %eax
    jge eexittt
    mov 4(%ebp), %eax
    mov %eax, 8(%ebp)

    dellete4:
        mov 8(%ebp), %ebx
        mov (%edi, %ebx, 4), %esi
        cmp %esi, 12(%ebp)
        jne eexittt
        movl $0, (%edi, %ebx, 4)
        incl 8(%ebp)
        jmp dellete4

    eexittt:
        ret

geet3:
    mov descriptor, %ecx
    mov %ecx, 8(%ebp)
    mov i, %ecx
    mov %ecx, 12(%ebp)

    et_gget1:
        mov 12(%ebp), %eax
        cmp $1048576, %eax
        jge eexitt2
        mov %eax, 4(%ebp)
    et_gget4:
        mov %eax, %ebx
        mov (%edi, %ebx, 4), %esi
        cmp $1048576, %eax
        je eexitt2
        cmp %esi, 8(%ebp)
        jne eexitt2
        incl 4(%ebp)
        mov 4(%ebp), %eax
        jmp et_gget4
    eexitt2:
        mov 4(%ebp), %eax
        subl 12(%ebp), %eax
        mov %eax, spatiu
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
    je add2
    jmp var2
add2:
    push %ebp
    mov %esp, %ebp
    sub $36, %esp
    call matrice_add
    add $44, %esp
    jmp adaug
var2:
    mov nume_comanda, %edx
    cmp $2, %edx
    je get
    jmp var3
get:
    push %ebp
    mov %esp, %ebp
    sub $28, %esp
    call get3
    add $36, %esp
    jmp adaug
var3:
    mov nume_comanda, %edx
    cmp $3, %edx
    je delete
    jmp var4
delete:
    push %ebp
    mov %esp, %ebp
    sub $16, %esp
    call delete0
    add $16, %esp
    jmp adaug
var4:
    mov nume_comanda, %edx
    cmp $4, %edx
    je defr0
    jmp adaug
defr0:
    movl $0, %eax
    mov %eax, poz
    movl $0, %eax
    mov %eax, i
defr1:
    mov i, %eax
    cmp $1048576, %eax
    jge adaug
    mov (%edi, %eax, 4), %esi
    cmp $0, %esi
    je crestere_i
    mov %esi, descriptor

    push %ebp
    mov %esp, %ebp
    sub $12, %esp
    call geet3
    add $12, %esp

    sub $12, %esp
    call dellete0
    add $12, %esp

    sub $36, %esp
    call matrice_add2
    add $40, %esp

    mov poz, %eax
    mov %eax, i
    jmp defr1

    crestere_i:
        incl i
        jmp defr1
    
adaug:
    incl ecx_copy2
    mov ecx_copy2, %ecx
    jmp inceput

iesire:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
