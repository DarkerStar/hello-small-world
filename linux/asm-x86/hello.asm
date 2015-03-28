; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

; This is a basic "Hello, world!" program, written in 32-bit x86 assembly.
; It is a "normal" assembly program, intended to be built in the normal way
; using NASM.

BITS    32              ; Specify 32-bit mode
GLOBAL _start           ; Entry point

SECTION .data

data:
                db      "Hello, world!",0x0A            ; The message to print

data_size       equ     $ - data                        ; Message length

SECTION .text

_start:
                ; Write message to stdout
                xor     edx, edx                        ; Zero edx (see note 1)
                xor     ebx, ebx                        ; Zero ebx
                xor     eax, eax                        ; Zero eax
                mov     dl, data_size                   ; edx = length of message
                mov     ecx, data                       ; ecx = address of message
                mov     bl, 1                           ; ebx = 1 (stdout)
                mov     al, 4                           ; eax = 4 (sys_write)
                int     0x80                            ; Do syscall
                
                ; Test return value, and set ebx to 0 or 1 accordingly
                xor     ebx, ebx                        ; Zero ebx
                cmp     eax, data_size                  ; Did all chars get written?
                je      .success                        ; If yes, we're done (ebx = 0)
                inc     ebx                             ; Otherwise ebx = 1
.success:
                
                ; Exit with status to 0
                xor     eax, eax                        ; Zero eax
                                                        ; ebx = 0 or 1
                inc     eax                             ; eax = 1 (sys_exit)
                int     0x80                            ; Do syscall

; Note 1:
;   Doing "xor e?x, e?x" (2 bytes) then "mov ?l, ##" (2 bytes) is 1 byte shorter
; than doing "mov e?x, ##" (5 bytes)... so long as 0<= ## <256.
