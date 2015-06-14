; ------------------------------------------------------------------------------
; The FizzBuzz programmer test written in x86-64 on Linux using NASM
;
; The problem is:
;
;   Write a program that prints the numbers from 1 to 100. But for
;   multiples of three print "Fizz" instead of the number and for the
;   multiples of five print "Buzz". For numbers which are multiples of
;   both three and five print "FizzBuzz"
;   See: https://en.wikipedia.org/wiki/Fizz_buzz
;
; Author: Paul Hornsey (paul@1partcarbon.co.uk)
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
section .data
; ------------------------------------------------------------------------------

fizz:   db        "Fizz"
buzz:   db        "Buzz"
cr:     db        10

; ------------------------------------------------------------------------------
section .text
; ------------------------------------------------------------------------------

        global _start

_start:
       call        print_fizz
       call        print_buzz
       call        print_fizzbuzz
       jmp         exit_0

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; If 0 exit after

print_fizzbuzz:
        ; set a = 1
        ; jmp print_fizz
        mov        rbx, 1                      ; rbx = 1 (fizz and buzz)
        jmp        do_fizz

print_fizz:
        xor        rbx, rbx                    ; rbx = 0 (only print fizz)

do_fizz:
        ; print "Fizz"
        ; if a == 0 skip to new line print
        ;ret
        ; print "Buzz"
        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, fizz                   ; string
        mov        rdx, 4                      ; length
        syscall

        cmp        rbx, 1                      ; if rbx == 1 then continue
        jne        print_new_line              ; on to print_buzz else move
                                               ; past to print a new_line
print_buzz:
        ; print "Buzz"
        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, buzz                   ; string
        mov        rdx, 4                      ; length
        syscall

print_new_line:
        ; print "\n"
        mov     rax, 1                      ; sys_write
        mov     rdi, 1                      ; stdout
        mov     rsi, cr                     ; string
        mov     rdx, 1                      ; length
        syscall

        ret

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; ----------------------------------------------------------
; Exit program and pass 0 (success) back to calling OS.
; ----------------------------------------------------------
exit_0:
        mov     rax, 60                     ; sys_exit
        xor     rdi, rdi
        syscall

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
