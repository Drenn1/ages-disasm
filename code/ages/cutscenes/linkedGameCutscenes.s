; TODO: Some of this file is probably shared with the Seasons version? Should try to merge them as
; much as possible.

;;
; Called from "func_3ed0" in bank 0.
; CUTSCENE_FLAME_OF_SORROW
func_03_7841:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw _func_03_7851
	.dw _flameOfSorrowState1

;;
; Called from "func_3ee4" in bank 0.
; CUTSCENE_ZELDA_KIDNAPPED
func_03_7849:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw _func_03_7851
	.dw _zeldaKidnappedState1

;;
_func_03_7851:
	ld b,$10
	ld hl,wTmpcbb3
	call clearMemory
	call clearWramBank1
	xor a
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,$01
	ld (wCutsceneState),a
	ret

;;
_flameOfSorrowState1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
@substate0:
	ld a,$28
	ld (wTmpcbb5),a
	jp _linkedCutscene_incSubstate
@substate1:
	call _func_03_7b95
	ret nz
	call _func_7bab
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
	inc l
	ld (hl),$01
+
	ld a,$13
	call loadGfxRegisterStateIndex
	ld a,SND_LIGHTNING
	call playSound
	xor a
	ld (wTmpcbb5),a
	ld (wTmpcbb6),a
	dec a
	ld (wTmpcbba),a
	call _linkedCutscene_incSubstate
@substate2:
	ld hl,wTmpcbb5
	ld b,$05
	call flashScreen
	ret z
	call clearPaletteFadeVariablesAndRefreshPalettes
	jp _linkedCutscene_incSubstate
@substate3:
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_TWINROVA_FLAME
+
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	call _clearFadingPalettes
	ld a,$bf
	ldh (<hSprPaletteSources),a
	ldh (<hDirtySprPalettes),a
	ld a,$04
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate4:
	call _func_03_7b95
	ret nz

	ld a,TEXTBOXFLAG_ALTPALETTE1
	ld (wTextboxFlags),a
	ld c,<TX_281b
	jp _func_03_7b81
@substate5:
	call _func_7b9a
	ret nz
	ld b,$10
	call @func_78fd
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@func_78fd:
	call fastFadeinFromBlack
	ld a,b
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	xor a
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld a,SND_LIGHTTORCH
	jp playSound
@substate6:
	call _func_7ba1
	ret nz
	call fadeinFromBlack
	ld a,$af
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a
	call _func_7bd0
	ld a,MUS_DISASTER
	ld (wActiveMusic),a
	call playSound
	xor a
	ld ($cfc6),a
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate7:
	call _func_7ba1
	ret nz
	ld c,<TX_2829
	jp _func_03_7b81
@substate8:
	call _func_7b9a
	ret nz
	ld c,<TX_281c
	jp _func_03_7b81
@substate9:
	call _func_7b9a
	ret nz
	ld c,<TX_281d
	jp _func_03_7b81
@substateA:
	call _func_7b9a
	ret nz
	ld c,<TX_281e
	call _func_03_7b81
	ld a,$3c
	ld (wTmpcbb5),a
	ret
@substateB:
	call _func_7b9a
	ret nz
	xor a
	ld (wMenuDisabled),a
	ld hl,@warpDest
	call setWarpDestVariables
	ld a,$00
	ld (wcc50),a
	ld a,PALH_0f
	jp loadPaletteHeader

@warpDest:
	m_HardcodedWarpA ROOM_AGES_4ea, $0c, $87, $83

_zeldaKidnappedState1:
	call @runStates
	jp updateStatusBar
@runStates:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
	.dw @substateC
	.dw @substateD
	.dw @substateE
	.dw @substateF
	.dw @substate10
	.dw @substate11
	.dw @substate12
	.dw @substate13
	.dw @substate14
	.dw @substate15
	.dw @substate16
@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld bc, ROOM_AGES_149
	call disableLcdAndLoadRoom
	ld a,$02
	call loadGfxRegisterStateIndex
	call restartSound
	call _func_7c2a
	call fadeinFromWhite
	ld a,$3c
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate1:
	call _func_7ba1
	ret nz
	ld hl,$cfc0
	set 0,(hl)
	ld a,$01
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate2:
	ld hl,$cfc0
	bit 1,(hl)
	ret z
	call _func_03_7b95
	ret nz
	xor a
	call _func_7c68
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate3:
	call _func_03_7b95
	ret nz
	xor a
	call _func_7c83
	ld hl,$cfc0
	set 2,(hl)
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate4:
	call _func_03_7b95
	ret nz
	ld a,$01
	call _func_7c68
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate5:
	call _func_03_7b95
	ret nz
	ld a,$01
	call _func_7c83
	ld hl,$cfc0
	set 3,(hl)
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate6:
	ld hl,$cfc0
	bit 4,(hl)
	ret z
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate7:
	call _func_03_7b95
	ret nz
	ld hl,$cfc0
	set 5,(hl)
	ld a,$28
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate8:
	call _func_03_7b95
	ret nz
	ld c,<TX_281f
	call _func_03_7b81
	ld a,$5a
	ld (wTmpcbb5),a
	ret
@substate9:
	call _func_7b9a
	jr z,@func_7a63
	ld a,$3c
	cp (hl)
	ret nz
	ld hl,$cfc0
	set 6,(hl)
	ret
@func_7a63:
	ld hl,$cfc0
	set 7,(hl)
	ld a,$3c
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substateA:
	call _func_03_7b95
	ret nz
	call _func_7c1f
	call _func_7beb
	ld a,MUS_DISASTER
	ld (wActiveMusic),a
	call playSound
	xor a
	ld ($cfc0),a
	ld ($cfc6),a
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substateB:
	ld a,($cfc0)
	bit 0,a
	ret z
	call _func_03_7b95
	ret nz
	ld c,<TX_2820
	jp _func_03_7b81
@substateC:
	call _func_7b9a
	ret nz
	ld c,<TX_2821
	jp _func_03_7b81
@substateD:
	call _func_7b9a
	ret nz
	ld c,<TX_2822
	jp _func_03_7b81
@substateE:
	call _func_7b9a
	ret nz
	ld hl,$cfc0
	res 0,(hl)
	jp _linkedCutscene_incSubstate
@substateF:
	ld a,($cfc0)
	bit 0,a
	ret z
	ld a,SND_LIGHTNING
	call playSound
	xor a
	ld (wTmpcbb4),a
	call _linkedCutscene_incSubstate
@substate10:
	call _func_7b48
	ret nz
	call clearDynamicInteractions
	ld hl,$cfc0
	res 0,(hl)
	xor a
	ld ($cfc6),a
	ld a,$04
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate11:
	call _func_03_7b95
	ret nz
	call _func_7c1f
	call _func_7bf6
	call _func_7c2f
	ld a,$04
	call fadeinFromWhiteWithDelay
	ld a,$1e
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate12:
	call _func_7ba1
	ret nz
	ld c,<TX_2823
	jp _func_03_7b81
@substate13:
	call _func_7b9a
	ret nz
	ld c,<TX_2824
	jp _func_03_7b81
@substate14:
	call _func_7b9a
	ret nz
	ld a,SND_BEAM2
	call playSound
	ld hl,$cfc0
	set 0,(hl)
	ld a,$5a
	jp _linkedCutscene_aIntoCBB5_incSubstate
@substate15:
	call _func_03_7b95
	ret nz
	dec a
	ld (wTmpcbba),a
	ld a,SND_LIGHTNING
	call playSound
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	jp _linkedCutscene_incSubstate
@substate16:
	ld hl,wTmpcbb5
	ld b,$02
	call flashScreen
	ret z
	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call setGlobalFlag
	xor a
	ld (wMenuDisabled),a
	ld a,CUTSCENE_FLAME_OF_DESPAIR
	ld (wCutsceneTrigger),a
	ret

_func_7b48:
	ld a,(wTmpcbb4)
	rst_jumpTable
	.dw @cbb4_00
	.dw @cbb4_01
	.dw @cbb4_02
	.dw @cbb4_03
	.dw @cbb4_04
	.dw @cbb4_05
@cbb4_00:
	ld a,$0a
---
	ld (wTmpcbb5),a
	call clearFadingPalettes
	jp _func_03_7b90
@cbb4_01:
@cbb4_02:
	call _func_03_7b95
	ret nz
	ld a,$0a
--
	ld (wTmpcbb5),a
	call fastFadeoutToWhite
	jp _func_03_7b90
@cbb4_03:
	ld a,$14
	jr ---
@cbb4_04:
	call _func_03_7b95
	ret nz
	ld a,$1e
	jr --
@cbb4_05:
	jp _func_7ba1


;;
; @param c Low byte of text index
_func_03_7b81:
	ld b,$28
	call showText
	ld a,$1e
_linkedCutscene_aIntoCBB5_incSubstate:
	ld (wTmpcbb5),a
_linkedCutscene_incSubstate:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
_func_03_7b90:
	ld hl,wTmpcbb4
	inc (hl)
	ret

;;
_func_03_7b95:
	ld hl,wTmpcbb5
	dec (hl)
	ret

_func_7b9a:
	ld a,(wTextIsActive)
	or a
	ret nz
	jr ++

_func_7ba1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
++
	ld hl,wTmpcbb5
	dec (hl)
	ret


_func_7bab:
	xor a
	ld bc,ROOM_ZELDA_IN_FINAL_DUNGEON
	call disableLcdAndLoadRoom
	ld a,PALH_ac
	call loadPaletteHeader
	ld a,$28
	ld (wGfxRegs1.SCX),a
	ld (wGfxRegs2.SCX),a
	ldh (<hCameraX),a
	xor a
	ldh (<hCameraY),a
	ld a,$00
	ld (wScrollMode),a
	ld a,$10
	ldh (<hOamTail),a
	jp clearWramBank1


_func_7bd0:
	ld bc,_table_7be5
	call _func_7bd9
	ld bc,_table_7be8
_func_7bd9:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TWINROVA_IN_CUTSCENE
	inc l
	ld a,(bc)
	inc bc
	ld (hl),a
	jr _func_7c09
_table_7be5:
	.db $02 $4c $8e
_table_7be8:
	.db $03 $4c $62


_func_7beb:
	ld bc,_table_7c13
	call _func_7bff
	ld bc,_table_7c16
	jr _func_7bff


_func_7bf6:
	ld bc,_table_7c19
	call _func_7bff
	ld bc,_table_7c1c
_func_7bff:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TWINROVA_3
	inc l
	ld a,(bc)
	inc bc
	ld (hl),a
_func_7c09:
	ld l,Interaction.yh
	ld a,(bc)
	inc bc
	ld (hl),a
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	ret
_table_7c13:
	nop
	nop
	ld b,b
_table_7c16:
	.db $01 $00 $60

_table_7c19:
	.db $02 $50 $68

_table_7c1c:
	.db $03 $50 $38


_func_7c1f:
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	ld a,$bc
	ld (wInteractionIDToLoadExtraGfx),a
	ret


_func_7c2a:
	ld bc,_table_7c4e
	jr _spawnZeldaKidnappedNPCs

_func_7c2f:
	ld bc,_table_7c5d

_spawnZeldaKidnappedNPCs:
	ld a,(bc)
	or a
	ret z
	call getFreeInteractionSlot
	ret nz
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	inc bc
	jr _spawnZeldaKidnappedNPCs

_table_7c4e:
	; id - subid - var03 - yh - xh
	.db INTERACID_BOY,              $0f $03 $48 $48
	.db INTERACID_IMPA_IN_CUTSCENE, $08 $03 $48 $58
	.db INTERACID_ZELDA,            $09 $02 $38 $50
_table_7c5d:
	.db INTERACID_VILLAGER,         $0e $01 $48 $38
	.db INTERACID_PAST_GUY,         $07 $00 $28 $78
	.db $00


_func_7c68:
	ld bc,_table_7c7f
	call addDoubleIndexToBc
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl)
	ld l,Part.yh
	ld a,(bc)
	ldi (hl),a
	inc bc
	inc l
	ld a,(bc)
	ld (hl),a
	ret

_table_7c7f:
	.db $58 $38
	.db $48 $68

_func_7c83:
	ld bc,_table_7c7f
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_MISCELLANEOUS_1
	inc l
	ld (hl),$16
	ld l,Interaction.counter1
	ld (hl),$78
	jp _func_7c09
