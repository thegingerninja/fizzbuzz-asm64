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
section .data                                  ; Constants
; ------------------------------------------------------------------------------

fizz:               db        "Fizz"
buzz:               db        "Buzz"
cr:                 db        10

last_num:           equ       10               ; Numbers go from 1 to last_num

; ------------------------------------------------------------------------------
section .bss                                   ; variables
; ------------------------------------------------------------------------------

output_buffer:      resb   1                   ; Buffer for digit print

; ------------------------------------------------------------------------------
section .text                                  ; program
; ------------------------------------------------------------------------------

        global _start

_start:
        xor        r8, r8                      ; R8 - Loop counter e.g. 1..100
        mov        r9, 9

main_loop:
        inc        r8

        ; do checks and print
        ;call       print_fizz

        ; temp: check 9..0 digits print
        call       print_byte_as_num
        dec        r9

        cmp        r8, last_num
        je         exit_0                      ; Exit once 100 reached
        jmp        main_loop                   ; else keep looping


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; If 0 exit after

print_fizzbuzz:
        mov        rbx, 1                      ; rbx = 1 (fizz and buzz)
        jmp        do_fizz

print_fizz:
        xor        rbx, rbx                    ; rbx = 0 (only print fizz)

do_fizz:
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
        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, cr                     ; string
        mov        rdx, 1                      ; length
        syscall

        ret

; ----------------------------------------------------------
; Print a positive integer in Ascii to stdout
; Input: r9 = byte to print
; r9 is preserved
; ----------------------------------------------------------
print_byte_as_num:
        push       r9

        add        r9, 0x30                    ; Convert int to char
        mov        [output_buffer], r9

        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, output_buffer          ; the ascii
        mov        rdx, 1                      ; length
        syscall

        call       print_new_line

        pop        r9
        ret

; ----------------------------------------------------------
; Exit program and pass 0 (success) back to calling OS.
; ----------------------------------------------------------
exit_0:
        mov        rax, 60                     ; sys_exit
        xor        rdi, rdi
        syscall

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
