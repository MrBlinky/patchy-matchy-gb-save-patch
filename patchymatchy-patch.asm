;---------------------------------------------------------------
;Save reset patch for Patchy Matchy        by Mr.Blinky Nov.2024
;
;use RGBASM to build
;
;Dec 2025 add support for rom v1.1

;---------------------------------------------------------------

IF DEF (V10)

;V1.0 (V23 on copyright screen)

DEF ACHIEVEMENTS            EQU $C0FE
DEF SIZE_OF_ACHIEVEMENTS    EQU $11
DEF SOUND                   EQU $C112

DEF SCAN_JOYPAD             EQU $78DE
DEF LOAD_PATCH_ADDR         EQU $525A
DEF LOAD_SAVE_PATCH_ADDR    EQU $7FA5

DEF SAVE_ACHIEVEMENT1_ADDR  EQU $2FAC
DEF SAVE_ACHIEVEMENT2_ADDR  EQU $2FD7
DEF SAVE_ACHIEVEMENT3_ADDR  EQU $2FF5
DEF SAVE_ACHIEVEMENT4_ADDR  EQU $3D7D
DEF SAVE_ACHIEVEMENT5_ADDR  EQU $3D9B
DEF SAVE_ACHIEVEMENT6_ADDR  EQU $3DB9
DEF SAVE_ACHIEVEMENT7_ADDR  EQU $3DD7
DEF SAVE_ACHIEVEMENT8_ADDR  EQU $3E8A
DEF SAVE_ACHIEVEMENT9_ADDR  EQU $3EA8
DEF SAVE_ACHIEVEMENT10_ADDR  EQU $3EC6
DEF SAVE_ACHIEVEMENT11_ADDR  EQU $3EE4
DEF SAVE_ACHIEVEMENT12_ADDR  EQU $3F18
DEF SAVE_ACHIEVEMENT13_ADDR  EQU $3F35
DEF SAVE_ACHIEVEMENT14_ADDR  EQU $3F57
DEF SAVE_ACHIEVEMENT15_ADDR  EQU $4690
DEF SAVE_ACHIEVEMENT16_ADDR  EQU $5112
DEF SAVE_ACHIEVEMENT17_ADDR  EQU $5D2E

ELIF DEF (V11)

;V1.1 (V24 on copyright screen)

DEF ACHIEVEMENTS            EQU $C0FE
DEF SIZE_OF_ACHIEVEMENTS    EQU $11
DEF SOUND                   EQU $C112

DEF SCAN_JOYPAD             EQU $7765
DEF LOAD_PATCH_ADDR         EQU $5140
DEF LOAD_SAVE_PATCH_ADDR    EQU $7E2C

DEF SAVE_ACHIEVEMENT1_ADDR  EQU $2F74
DEF SAVE_ACHIEVEMENT2_ADDR  EQU $2F9F
DEF SAVE_ACHIEVEMENT3_ADDR  EQU $2FBD
DEF SAVE_ACHIEVEMENT4_ADDR  EQU $3D45
DEF SAVE_ACHIEVEMENT5_ADDR  EQU $3D63
DEF SAVE_ACHIEVEMENT6_ADDR  EQU $3D81
DEF SAVE_ACHIEVEMENT7_ADDR  EQU $3D9F
DEF SAVE_ACHIEVEMENT8_ADDR  EQU $3E52
DEF SAVE_ACHIEVEMENT9_ADDR  EQU $3E70
DEF SAVE_ACHIEVEMENT10_ADDR  EQU $3E8E
DEF SAVE_ACHIEVEMENT11_ADDR  EQU $3EAC
DEF SAVE_ACHIEVEMENT12_ADDR  EQU $3EE0
DEF SAVE_ACHIEVEMENT13_ADDR  EQU $3EFD
DEF SAVE_ACHIEVEMENT14_ADDR  EQU $3F1F
DEF SAVE_ACHIEVEMENT15_ADDR  EQU $45AF
DEF SAVE_ACHIEVEMENT16_ADDR  EQU $5031
DEF SAVE_ACHIEVEMENT17_ADDR  EQU $5C00

ENDC

;-------------------------------------------------------------------------------
; save patch
;-------------------------------------------------------------------------------

DEF rRAMG           EQU $0000
DEF rRAMB           EQU $4000
DEF _SRAM           EQU $A000

    SECTION "header cart type",ROM0[$0147]

    db   $03    ;MBC1 + RAM + BATTERY

    SECTION "header ramsize",ROM0[$0149]

    db   $02    ;8K ramsize

    SECTION "header checksums",ROM0[$014D]

    db   $00    ;header checksum
    dw   $0000  ;global checksum

;---------------------------------------
    SECTION "load patch 1",ROM0[LOAD_PATCH_ADDR]
    
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
    SECTION "save achievement 1",ROM0[SAVE_ACHIEVEMENT1_ADDR]
    
    call save_patch
    
    SECTION "save achievement 2",ROM0[SAVE_ACHIEVEMENT2_ADDR]
    
    call save_patch
    
    SECTION "save achievement 3",ROM0[SAVE_ACHIEVEMENT3_ADDR]
    
    call save_patch
    
    SECTION "save achievement 4",ROM0[SAVE_ACHIEVEMENT4_ADDR]
    
    call save_patch
    
    SECTION "save achievement 5",ROM0[SAVE_ACHIEVEMENT5_ADDR]
    
    call save_patch
    
    SECTION "save achievement 6",ROM0[SAVE_ACHIEVEMENT6_ADDR]
    
    call save_patch
    
    SECTION "save achievement 7",ROM0[SAVE_ACHIEVEMENT7_ADDR]
    
    call save_patch
    
    SECTION "save achievement 8",ROM0[SAVE_ACHIEVEMENT8_ADDR]
    
    call save_patch
    
    SECTION "save achievement 9",ROM0[SAVE_ACHIEVEMENT9_ADDR]
    
    call save_patch
    
    SECTION "save achievement 10",ROM0[SAVE_ACHIEVEMENT10_ADDR]
    
    call save_patch
    
    SECTION "save achievement 11",ROM0[SAVE_ACHIEVEMENT11_ADDR]
    
    call save_patch
    
    SECTION "save achievement 12",ROM0[SAVE_ACHIEVEMENT12_ADDR]
    
    call save_patch
    
    SECTION "save achievement 13",ROM0[SAVE_ACHIEVEMENT13_ADDR]
    
    call save_patch
    
    SECTION "save achievement 14",ROM0[SAVE_ACHIEVEMENT14_ADDR]
    
    call save_patch
    
    SECTION "save achievement 15",ROM0[SAVE_ACHIEVEMENT15_ADDR]
    
    call save_patch
    
    SECTION "save achievement 16",ROM0[SAVE_ACHIEVEMENT16_ADDR]
    
    call save_patch
    
    SECTION "save achievement 17",ROM0[SAVE_ACHIEVEMENT17_ADDR]
    
    call save_patch

;---------------------------------------
    SECTION "loadsave patch",ROM0[LOAD_SAVE_PATCH_ADDR]
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
