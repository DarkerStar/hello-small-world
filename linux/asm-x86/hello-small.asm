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
; It is intended to be assembled by NASM, using the flat-file output option.
; The assembly commands should be:
;   nasm -f bin -o hello hello.asm
;   chmod +x hello
; The code is based on the "Really Teensy ELF" described at:
;   http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html
; However, no underhanded hacks were used - the program is a basic, legal ELF.
; There is no overlap of sections, and no mucking about with the parts of the
; ELF and program header that Linux doesn't (currently) check.

BITS  32                ; Specify 32-bit mode (necessary in flat-file output)
ORG   0x08048000        ; Standard origin address for ELF programs
                
elf_header:                                             ; Elf32_Ehdr
                db      0x7F, "ELF", 1, 1, 1            ;   e_ident
        times 9 db      0
                dw      2                               ;    e_type
                dw      3                               ;    e_machine
                dd      1                               ;    e_version
                dd      _start                          ;    e_entry
                dd      program_header - $$             ;    e_phoff
                dd      0                               ;    e_shoff
                dd      0                               ;    e_flags
                dw      elf_header_size                 ;    e_ehsize
                dw      program_header_size             ;    e_phentsize
                dw      1                               ;    e_phnum
                dw      0                               ;    e_shentsize
                dw      0                               ;    e_shnum
                dw      0                               ;    e_shstrndx

elf_header_size         equ     $ - elf_header


program_header:                                         ;  Elf32_Phdr
                dd      1                               ;    p_type
                dd      0                               ;    p_offset
                dd      $$                              ;    p_vaddr
                dd      $$                              ;    p_paddr
                dd      file_size                       ;    p_filesz
                dd      file_size                       ;    p_memsz
                dd      5                               ;    p_flags
                dd      0x1000                          ;    p_align

program_header_size     equ     $ - program_header


data:
                db      "Hello, world!",0x0A            ; The message to print

data_size       equ     $ - data                        ; Message length


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

file_size       equ    $ - $$

; Note 1:
;   Doing "xor e?x, e?x" (2 bytes) then "mov ?l, ##" (2 bytes) is 1 byte shorter
; than doing "mov e?x, ##" (5 bytes)... so long as 0<= ## <256.
