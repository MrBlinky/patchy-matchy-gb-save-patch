;---------------------------------------------------------------
;Save reset patch for Patchy Matchy        by Mr.Blinky Nov.2024
;
;use RGBASM to build
;
;---------------------------------------------------------------

DEF ACHIEVEMENTS            EQU $C0FE
DEF SIZE_OF_ACHIEVEMENTS    EQU $11
DEF SOUND                   EQU $C112
DEF SCAN_JOYPAD             EQU $78DE

;-------------------------------------------------------------------------------
; save patch
;-------------------------------------------------------------------------------

DEF rRAMG           EQU $0000
DEF rRAMB           EQU $4000
DEF _SRAM           EQU $A000

    SECTION "header cart type",ROM0[$0147]

    db   $03    ;MBC1 + RAM + BATTERY

    SECTION "header ramsize",ROM0[$0149]

    db   $01    ;2K ramsize

    SECTION "header checksums",ROM0[$014D]

    db   $00    ;header checksum
    dw   $0000  ;global checksum

;---------------------------------------
    SECTION "load patch 1",ROM0[$525A]

    xor  a
    ld   hl,ACHIEVEMENTS
    ld   b,SIZE_OF_ACHIEVEMENTS
clear_achievements:
    ldi  [hl],a
    dec b
    jr nz,clear_achievements
    call SCAN_JOYPAD
    cp   $C0                ;test START+SELECT pressed
    call nz,load_patch      ;load save if not pressed

;---------------------------------------
    SECTION "save achievement 1",ROM0[$2FAC]
    
    call save_patch
    
    SECTION "save achievement 2",ROM0[$2FD7]
    
    call save_patch
    
    SECTION "save achievement 3",ROM0[$2FF5]
    
    call save_patch
    
    SECTION "save achievement 4",ROM0[$3D7D]
    
    call save_patch
    
    SECTION "save achievement 5",ROM0[$3D9B]
    
    call save_patch
    
    SECTION "save achievement 6",ROM0[$3DB9]
    
    call save_patch
    
    SECTION "save achievement 7",ROM0[$3DD7]
    
    call save_patch
    
    SECTION "save achievement 8",ROM0[$3E8A]
    
    call save_patch
    
    SECTION "save achievement 9",ROM0[$3EA8]
    
    call save_patch
    
    SECTION "save achievement 10",ROM0[$3EC6]
    
    call save_patch
    
    SECTION "save achievement 11",ROM0[$3EE4]
    
    call save_patch
    
    SECTION "save achievement 12",ROM0[$3F18]
    
    call save_patch
    
    SECTION "save achievement 13",ROM0[$3F35]
    
    call save_patch
    
    SECTION "save achievement 14",ROM0[$3F57]
    
    call save_patch
    
    SECTION "save achievement 15",ROM0[$4690]
    
    call save_patch
    
    SECTION "save achievement 16",ROM0[$5112]
    
    call save_patch
    
    SECTION "save achievement 17",ROM0[$5D2E]
    
    call save_patch

;---------------------------------------
    SECTION "loadsave patch",ROM0[$7FA5]
;---------------------------------------

load_patch:

    call save_init
load_check:
    ld   a,[de]         ;check game title in save
    cp   [hl]
    inc  de
    inc  hl
    jr   nz,load_end
    add  c              ;update checksum
    ld   c,a
    dec  b
    jr   nz,load_check

    ld   d,h            ;save pointer to save data in DE
    ld   e,l
    ld   b,SIZE_OF_ACHIEVEMENTS
load_checkcum:
    ldi  a,[hl]         ;get checksum over save data
    add  c
    ld   c,a
    dec  b
    jr   nz,load_checkcum
    cp   [hl]           ;compare checksums
    jr   nz,load_end

    ;checksum ok, load save data

    ld   hl,ACHIEVEMENTS
    call copy_achievements
load_end:
    jr   sram_disable
    
;--------------------------------------
save_patch:
    call save_init
    call copy_b_bytes
    ld   de,ACHIEVEMENTS
    call copy_achievements
    ld   [hl],c         ;store checksum
    ld   hl,SOUND
sram_disable:    
    xor  a              ;disable ram
    ld   [rRAMG],a
    ret

;--------------------------------------
save_init:
    xor  a              ;ram bank 0
    ld   [rRAMB],a
    ld   a,$0A    	    ;enable SRAM
    ld   [rRAMG],a
    ld   hl,_SRAM       ;start of save ram
    ld   de,$0134       ;game title in header
    ld   b,15           ;game title length
    ld   c,l            ;clear checksum
    ret

;--------------------------------------
copy_achievements:
    ld   b,SIZE_OF_ACHIEVEMENTS
   ;fallthrough

copy_b_bytes:
    ld   a,[de]
    inc  de
    ldi  [hl],a
    add  a,c
    ld   c,a
    dec  b
    jr   nz,copy_b_bytes
    ret
