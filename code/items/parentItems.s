;;
; ITEMID_SHOOTER ($0f)
; ITEMID_SLINGSHOT ($13)
; @addr{4e66}
_parentItemCode_shooter:
_parentItemCode_slingshot:
	ld e,Item.state		; $4e66
	ld a,(de)		; $4e68
	rst_jumpTable			; $4e69
	.dw @state0
	.dw @state1
	.dw @state2

; Initialization
@state0:
	ld a,$01		; $4e70
	call _clearSelfIfNoSeeds		; $4e72

	call updateLinkDirectionFromAngle		; $4e75
	call _parentItemLoadAnimationAndIncState		; $4e78
	call itemCreateChild		; $4e7b
	ld a,(wLinkAngle)		; $4e7e
	bit 7,a			; $4e81
	jr z,@updateAngleFrom5Bit	; $4e83
	ld a,(w1Link.direction)		; $4e85
	add a			; $4e88
	jr @updateAngle		; $4e89


; Waiting for button to be released
@state1:
	ld a,$01		; $4e8b
	call _clearSelfIfNoSeeds		; $4e8d
	call _parentItemCheckButtonPressed		; $4e90
	jr nz,@checkUpdateAngle	; $4e93

; Button released

	ld a,(wIsSeedShooterInUse)		; $4e95
	or a			; $4e98
	jp nz,_clearParentItem		; $4e99

	ld e,Item.relatedObj2+1		; $4e9c
	ld a,>w1Link		; $4e9e
	ld (de),a		; $4ea0

	ld a,$01		; $4ea1
	call _clearSelfIfNoSeeds		; $4ea3

	; Note: here, 'c' = the "behaviour" value from the "_itemUsageParameterTable" for
	; button B, and this will become the subid for the new item? (The only important
	; thing is that it's nonzero, to indicate the seed came from the shooter.)
	push bc			; $4ea6
	ld e,$01		; $4ea7
	call itemCreateChildWithID		; $4ea9

	; Calculate child item's angle?
	ld e,Item.angle		; $4eac
	ld a,(de)		; $4eae
	add a			; $4eaf
	add a			; $4eb0
	ld l,Item.angle		; $4eb1
	ld (hl),a		; $4eb3

	pop bc			; $4eb4
	ld a,b			; $4eb5
	call decNumActiveSeeds		; $4eb6

	call itemIncState		; $4eb9
	ld l,Item.counter2		; $4ebc
	ld (hl),$0c		; $4ebe

	ld a,SND_SEEDSHOOTER		; $4ec0
	jp playSound		; $4ec2


; Waiting for counter to reach 0 before putting away the seed shooter
@state2:
	call itemDecCounter2		; $4ec5
	ret nz			; $4ec8
	ld a,(wLinkAngle)		; $4ec9
	push af			; $4ecc
	ld l,Item.angle		; $4ecd
	ld a,(hl)		; $4ecf
	add a			; $4ed0
	add a			; $4ed1
	ld (wLinkAngle),a		; $4ed2
	call updateLinkDirectionFromAngle		; $4ed5
	pop af			; $4ed8
	ld (wLinkAngle),a		; $4ed9
	jp _clearParentItem		; $4edc


; Note: seed shooter's angle is a value from 0-7, instead of $00-$1f like usual

@updateAngleFrom5Bit:
	rrca			; $4edf
	rrca			; $4ee0
	jr @updateAngle		; $4ee1

@checkUpdateAngle:
	ld a,(wGameKeysJustPressed)		; $4ee3
	and (BTN_RIGHT|BTN_LEFT|BTN_UP|BTN_DOWN)			; $4ee6
	jr nz,+			; $4ee8
	call itemDecCounter2		; $4eea
	jr nz,@determineBaseAnimation	; $4eed
+
	ld a,(wLinkAngle)		; $4eef
	rrca			; $4ef2
	rrca			; $4ef3
	jr c,@determineBaseAnimation	; $4ef4
	ld h,d			; $4ef6
	ld l,Item.angle		; $4ef7
	sub (hl)		; $4ef9
	jr z,@determineBaseAnimation	; $4efa

	bit 2,a			; $4efc
	ld a,$ff		; $4efe
	jr nz,+			; $4f00
	ld a,$01		; $4f02
+
	add (hl)		; $4f04

@updateAngle:
	ld h,d			; $4f05
	ld l,Item.angle		; $4f06
	and $07			; $4f08
	ld (hl),a		; $4f0a
	ld l,Item.counter2		; $4f0b
	ld (hl),$10		; $4f0d

@determineBaseAnimation:
	call _isLinkUnderwater		; $4f0f
	ld a,$48		; $4f12
	jr nz,++		; $4f14
	ld a,(w1Companion.id)		; $4f16
	cp SPECIALOBJECTID_MINECART			; $4f19
	ld a,$40		; $4f1b
	jr z,++			; $4f1d
	ld a,$38		; $4f1f
++
	ld h,d			; $4f21
	ld l,Item.angle		; $4f22
	add (hl)		; $4f24
	ld l,Item.var31		; $4f25
	ld (hl),a		; $4f27
	ld l,Item.var3f		; $4f28
	ld (hl),$04		; $4f2a
	ret			; $4f2c

;;
; ITEMID_SEED_SATCHEL ($19)
; @addr{4f2d}
_parentItemCode_satchel:
	ld e,Item.state		; $4f2d
	ld a,(de)		; $4f2f
	rst_jumpTable			; $4f30
	.dw @state0
	.dw _parentItemGenericState1

@state0:
	ld a,(w1Companion.id)		; $4f35
	cp SPECIALOBJECTID_RAFT			; $4f38
	jp z,_clearParentItem		; $4f3a
	call _isLinkUnderwater		; $4f3d
	jp nz,_clearParentItem		; $4f40
	ld a,(wLinkSwimmingState)		; $4f43
	or a			; $4f46
	jp nz,_clearParentItem		; $4f47

	call _clearSelfIfNoSeeds		; $4f4a

	ld a,b			; $4f4d
	cp $22			; $4f4e
	jr z,@pegasusSeeds	; $4f50

	push bc			; $4f52
	call _parentItemLoadAnimationAndIncState		; $4f53
	pop bc			; $4f56
	push bc			; $4f57
	ld c,$00		; $4f58
	ld e,$01		; $4f5a
	call itemCreateChildWithID		; $4f5c
	pop bc			; $4f5f
	jp c,_clearParentItem		; $4f60

	ld a,b			; $4f63
	jp decNumActiveSeeds		; $4f64

@pegasusSeeds:
	ld hl,wPegasusSeedCounter		; $4f67
	ldi a,(hl)		; $4f6a
	or (hl)			; $4f6b
	jr nz,@clear		; $4f6c

	ld a,$03		; $4f6e
	ldd (hl),a		; $4f70
	ld (hl),$c0		; $4f71

	ld a,b			; $4f73
	call decNumActiveSeeds		; $4f74

	; Create pegasus seed "puffs"?
	ld hl,w1ReservedItemF		; $4f77
	ld a,$03		; $4f7a
	ldi (hl),a		; $4f7c
	ld (hl),ITEMID_DUST		; $4f7d
@clear:
	jp _clearParentItem		; $4f7f

;;
; Gets the number of seeds available, or returns from caller if none are available.
;
; @param	a	0 for satchel, 1 for shooter
; @param[out]	a	# of seeds of that type
; @param[out]	b	Item ID for seed type (value between $20-$24)
; @param[out]	hl	Address of "wNum*Seeds" variable
; @addr{4f82}
_clearSelfIfNoSeeds:
	ld hl,wSatchelSelectedSeeds		; $4f82
	rst_addAToHl			; $4f85
	ld a,(hl)		; $4f86
	ld b,a			; $4f87
	set 5,b			; $4f88
	ld hl,wNumEmberSeeds		; $4f8a

	rst_addAToHl			; $4f8d
	ld a,(hl)		; $4f8e
	or a			; $4f8f
	ret nz			; $4f90
	pop hl			; $4f91
	jp _clearParentItem		; $4f92

;;
; This is "state 1" for the satchel, bombchu, and bomb "parent items". It simply updates
; Link's animation, then deletes the parent.
;
; @addr{4f95}
_parentItemGenericState1:
	ld e,Item.animParameter		; $4f95
	ld a,(de)		; $4f97
	rlca			; $4f98
	jp nc,_specialObjectAnimate		; $4f99
	jp _clearParentItem		; $4f9c


;;
; ITEMID_SHOVEL ($15)
; @addr{4f9f}
_parentItemCode_shovel:
	ld e,Item.state		; $4f9f
	ld a,(de)		; $4fa1
	rst_jumpTable			; $4fa2

	.dw @state0
	.dw @state1

@state0:
	call _checkLinkOnGround		; $4fa7
	jp nz,_clearParentItem		; $4faa
	jp _parentItemLoadAnimationAndIncState		; $4fad

@state1:
	call _specialObjectAnimate		; $4fb0
	ld e,Item.animParameter		; $4fb3
	ld a,(de)		; $4fb5
	bit 7,a			; $4fb6
	jp nz,_clearParentItem		; $4fb8

	; When [animParameter] == 1, create the child item
	dec a			; $4fbb
	ret nz			; $4fbc

	ld (de),a		; $4fbd
	call itemCreateChildIfDoesntExistAlready		; $4fbe

	; Calculate Y/X position to give to child item
	push hl			; $4fc1
	ld l,Item.direction		; $4fc2
	ld a,(hl)		; $4fc4
	ld hl,@offsets		; $4fc5
	rst_addDoubleIndex			; $4fc8
	ldi a,(hl)		; $4fc9
	ld c,(hl)		; $4fca
	pop hl			; $4fcb
	ld l,Item.yh		; $4fcc
	add (hl)		; $4fce
	ldi (hl),a		; $4fcf
	inc l			; $4fd0
	ld a,(hl)		; $4fd1
	add c			; $4fd2
	ldi (hl),a		; $4fd3
	ret			; $4fd4

@offsets:
	.db $f8 $00 ; DIR_UP
	.db $04 $06 ; DIR_RIGHT
	.db $07 $00 ; DIR_DOWN
	.db $04 $f9 ; DIR_LEFT


;;
; ITEMID_BOOMERANG ($06)
; @addr{4fdd}
_parentItemCode_boomerang:
	ld e,Item.state		; $4fdd
	ld a,(de)		; $4fdf
	rst_jumpTable			; $4fe0

	.dw @state0
	.dw @state1

@state0:
	call _isLinkUnderwater		; $4fe5
	jp nz,_clearParentItem		; $4fe8

	ld a,(w1ParentItem2.id)		; $4feb
	cp ITEMID_SWITCH_HOOK			; $4fee
	jp z,_clearParentItem		; $4ff0

	ld a,(wLinkSwimmingState)		; $4ff3
	or a			; $4ff6
	jp nz,_clearParentItem		; $4ff7

	call _parentItemLoadAnimationAndIncState		; $4ffa
	ld a,$01		; $4ffd
	ld e,Item.state		; $4fff
	ld (de),a		; $5001

	; Try to create the physical boomerang object, delete self on failure
	dec a			; $5002
	ld c,a			; $5003
	ld e,Item.id		; $5004
	ld a,(de)		; $5006
	ld b,a			; $5007
	ld e,$01		; $5008
	call itemCreateChildWithID		; $500a
	jp c,_clearParentItem		; $500d

	; Calculate angle for newly created boomerang
	ld a,(wLinkAngle)		; $5010
	bit 7,a			; $5013
	jr z,+			; $5015
	ld a,(w1Link.direction)		; $5017
	swap a			; $501a
	rrca			; $501c
+
	ld l,Item.angle		; $501d
	ld (hl),a		; $501f
	ld l,Item.var34		; $5020
	ld (hl),a		; $5022
	ret			; $5023

@state1:
	ld e,Item.animParameter		; $5024
	ld a,(de)		; $5026
	rlca			; $5027
	jp nc,_specialObjectAnimate		; $5028
	jp _clearParentItem		; $502b

;;
; ITEMID_BOMBCHUS ($0d)
; @addr{502e}
_parentItemCode_bombchu:
	ld e,Item.state		; $502e
	ld a,(de)		; $5030
	rst_jumpTable			; $5031
	.dw @state0
	.dw _parentItemGenericState1

@state0:
	; Must be above water
	call _isLinkUnderwater		; $5036
	jp nz,_clearParentItem		; $5039

	; Can't be on raft
	ld a,(w1Companion.id)		; $503c
	cp SPECIALOBJECTID_RAFT			; $503f
	jp z,_clearParentItem		; $5041

	; Can't be swimming
	ld a,(wLinkSwimmingState)		; $5044
	or a			; $5047
	jp nz,_clearParentItem		; $5048

	; Must have bombchus
	ld a,(wNumBombchus)		; $504b
	or a			; $504e
	jp z,_clearParentItem		; $504f

	call _parentItemLoadAnimationAndIncState		; $5052

	; Create a bombchu if there isn't one on the screen already
	ld e,$01		; $5055
	jp itemCreateChildAndDeleteOnFailure		; $5057

;;
; ITEMID_BOMB ($03)
; @addr{505a}
_parentItemCode_bomb:
	ld e,Item.state		; $505a
	ld a,(de)		; $505c
	rst_jumpTable			; $505d

	.dw @state0
	.dw _parentItemGenericState1
	.dw _parentItemCode_bracelet@state2
	.dw _parentItemCode_bracelet@state3
	.dw _parentItemCode_bracelet@state4

@state0:
	call _isLinkUnderwater		; $5068
	jp nz,_clearParentItem		; $506b

	; If Link is riding something other than a raft, don't allow usage of bombs
	ld a,(w1Companion.id)		; $506e
	cp SPECIALOBJECTID_RAFT			; $5071
	jr z,+			; $5073
	ld a,(wLinkObjectIndex)		; $5075
	rrca			; $5078
	jp c,_clearParentItem		; $5079
+
	ld a,(wLinkSwimmingState)		; $507c
	ld b,a			; $507f
	ld a,(wLinkInAir)		; $5080
	or b			; $5083
	jp nz,_clearParentItem		; $5084

	; Try to pick up a bomb
	call _tryPickupBombs		; $5087
	jp nz,_parentItemCode_bracelet@beginPickupAndSetAnimation		; $508a

	; Try to create a bomb
	ld a,(wNumBombs)		; $508d
	or a			; $5090
	jp z,_clearParentItem		; $5091

	call _parentItemLoadAnimationAndIncState		; $5094
	ld e,$01		; $5097
	ld a,BOMBERS_RING		; $5099
	call cpActiveRing		; $509b
	jr nz,+			; $509e
	inc e			; $50a0
+
	call itemCreateChild		; $50a1
	jp c,_clearParentItem		; $50a4

	call _makeLinkPickupObjectH		; $50a7
	jp _parentItemCode_bracelet@beginPickup		; $50aa

;;
; Makes Link pick up a bomb object if such an object exists and Link's touching it.
;
; @param[out]	zflag	Unset if a bomb was picked up
; @addr{50ad}
_tryPickupBombs:
	; Return if Link's using something?
	ld a,(wLinkUsingItem1)		; $50ad
	or a			; $50b0
	jr nz,@setZFlag	; $50b1

	; Return with zflag set if there is no existing bomb object
	ld c,ITEMID_BOMB		; $50b3
	call findItemWithID		; $50b5
	jr nz,@setZFlag	; $50b8

	call @pickupObjectIfTouchingLink		; $50ba
	ret nz			; $50bd

	; Try to find a second bomb object & pick that up
	ld c,ITEMID_BOMB		; $50be
	call findItemWithID_startingAfterH		; $50c0
	jr nz,@setZFlag	; $50c3


; @param	h	Object to check
; @param[out]	zflag	Set on failure (no collision with Link)
@pickupObjectIfTouchingLink:
	ld l,Item.var2f		; $50c5
	ld a,(hl)		; $50c7
	and $b0			; $50c8
	jr nz,@setZFlag	; $50ca
	call objectHCheckCollisionWithLink		; $50cc
	jr c,_makeLinkPickupObjectH	; $50cf

@setZFlag:
	xor a			; $50d1
	ret			; $50d2

;;
; @param	h	Object to make Link pick up
; @addr{50d3}
_makeLinkPickupObjectH:
	ld l,Item.enabled		; $50d3
	set 1,(hl)		; $50d5

	ld l,Item.state2		; $50d7
	xor a			; $50d9
	ldd (hl),a		; $50da
	ld (hl),$02		; $50db

	ld (w1Link.relatedObj2),a		; $50dd
	ld a,h			; $50e0
	ld (w1Link.relatedObj2+1),a		; $50e1
	or a			; $50e4
	ret			; $50e5


;;
; Bracelet's code is also heavily used by bombs.
;
; ITEMID_BRACELET ($16)
; @addr{50e6}
_parentItemCode_bracelet:
	ld e,Item.state		; $50e6
	ld a,(de)		; $50e8
	rst_jumpTable			; $50e9

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

; State 0: not grabbing anything
@state0:
	call _checkLinkOnGround		; $50f6
	jp nz,_clearParentItem		; $50f9
	ld a,(w1ReservedItemC.enabled)		; $50fc
	or a			; $50ff
	jp nz,_clearParentItem		; $5100

	call _parentItemCheckButtonPressed		; $5103
	jp z,@dropAndDeleteSelf		; $5106

	ld a,(wLinkUsingItem1)		; $5109
	or a			; $510c
	jr nz,++		; $510d

	; Check if there's anything to pick up
	call checkGrabbableObjects		; $510f
	jr c,@beginPickupAndSetAnimation	; $5112
	call _tryPickupBombs		; $5114
	jr nz,@beginPickupAndSetAnimation	; $5117

	; Try to grab a solid tile
	call @checkWallInFrontOfLink		; $5119
	jr nz,++		; $511c
	ld a,$41		; $511e
	ld (wLinkGrabState),a		; $5120
	jp _parentItemLoadAnimationAndIncState		; $5123
++
	ld a,(w1Link.direction)		; $5126
	or $80			; $5129
	ld (wBraceletGrabbingNothing),a		; $512b
	ret			; $512e


; State 1: grabbing a wall
@state1:
	call @deleteAndRetIfSwimmingOrGrabState0		; $512f
	ld a,(w1Link.knockbackCounter)		; $5132
	or a			; $5135
	jp nz,@dropAndDeleteSelf		; $5136

	call _parentItemCheckButtonPressed		; $5139
	jp z,@dropAndDeleteSelf		; $513c

	ld a,(wLinkInAir)		; $513f
	or a			; $5142
	jp nz,@dropAndDeleteSelf		; $5143

	call @checkWallInFrontOfLink		; $5146
	jp nz,@dropAndDeleteSelf		; $5149

	; Check that the correct direction button is pressed
	ld a,(w1Link.direction)		; $514c
	ld hl,@counterDirections		; $514f
	rst_addAToHl			; $5152
	call _andHlWithGameKeysPressed		; $5153
	ld a,LINK_ANIM_MODE_LIFT_3		; $5156
	jp z,specialObjectSetAnimationWithLinkData		; $5158

	; Update animation, wait for animParameter to set bit 7
	call _specialObjectAnimate		; $515b
	ld e,Item.animParameter		; $515e
	ld a,(de)		; $5160
	rlca			; $5161
	ret nc			; $5162

	; Try to lift the tile, return if not possible
	call @checkWallInFrontOfLink		; $5163
	jp nz,@dropAndDeleteSelf		; $5166
	lda BREAKABLETILESOURCE_00			; $5169
	call tryToBreakTile		; $516a
	ret nc			; $516d

	; Create the sprite to replace the broken tile
	ld hl,w1ReservedItemC.enabled		; $516e
	ld a,$03		; $5171
	ldi (hl),a		; $5173
	ld (hl),ITEMID_BRACELET		; $5174

	; Set subid to former tile ID
	inc l			; $5176
	ldh a,(<hFF92)	; $5177
	ldi (hl),a		; $5179
	ld e,Item.var37		; $517a
	ld (de),a		; $517c

	; Set child item's var03 (the interaction ID for the effect on breakage)
	ldh a,(<hFF8E)	; $517d
	ldi (hl),a		; $517f

	lda Item.start			; $5180
	ld (w1Link.relatedObj2),a		; $5181
	ld a,h			; $5184
	ld (w1Link.relatedObj2+1),a		; $5185

@beginPickupAndSetAnimation:
	ld a,LINK_ANIM_MODE_LIFT_4		; $5188
	call specialObjectSetAnimationWithLinkData		; $518a

@beginPickup:
	call _itemDisableLinkMovement		; $518d
	call _itemDisableLinkTurning		; $5190
	ld a,$c2		; $5193
	ld (wLinkGrabState),a		; $5195
	xor a			; $5198
	ld (wLinkGrabState2),a		; $5199
	ld hl,w1Link.collisionType		; $519c
	res 7,(hl)		; $519f

	ld a,$02		; $51a1
	ld e,Item.state		; $51a3
	ld (de),a		; $51a5
	ld e,Item.var3f		; $51a6
	ld a,$0f		; $51a8
	ld (de),a		; $51aa

	ld a,SND_PICKUP		; $51ab
	jp playSound		; $51ad


; Opposite direction to press in order to use bracelet
@counterDirections:
	.db BTN_DOWN	; DIR_UP
	.db BTN_LEFT	; DIR_RIGHT
	.db BTN_UP	; DIR_DOWN
	.db BTN_RIGHT	; DIR_LEFT


; State 2: picking an item up.
; This is also state 2 for bombs.
@state2:
	call @deleteAndRetIfSwimmingOrGrabState0		; $51b4
	call _specialObjectAnimate		; $51b7

	; Check if link's pulling a lever?
	ld a,(wLinkGrabState2)		; $51ba
	rlca			; $51bd
	jr nc,++		; $51be

	; Go to state 5 for lever pulling?
	ld a,$83		; $51c0
	ld (wLinkGrabState),a		; $51c2
	ld e,Item.state		; $51c5
	ld a,$05		; $51c7
	ld (de),a		; $51c9
	ld a,LINK_ANIM_MODE_LIFT_2		; $51ca
	jp specialObjectSetAnimationWithLinkData		; $51cc
++
	ld h,d			; $51cf
	ld l,Item.animParameter		; $51d0
	bit 7,(hl)		; $51d2
	jr nz,++		; $51d4

	; The animParameter determines the object's offset relative to Link?
	ld a,(wLinkGrabState2)		; $51d6
	and $f0			; $51d9
	add (hl)		; $51db
	ld (wLinkGrabState2),a		; $51dc
	ret			; $51df
++
	; Pickup animation finished
	ld a,$83		; $51e0
	ld (wLinkGrabState),a		; $51e2
	ld l,Item.state		; $51e5
	inc (hl)		; $51e7
	ld l,Item.var3f		; $51e8
	ld (hl),$00		; $51ea

	; Re-enable link collisions & movement
	ld hl,w1Link.collisionType		; $51ec
	set 7,(hl)		; $51ef
	call _itemEnableLinkTurning		; $51f1
	jp _itemEnableLinkMovement		; $51f4


; State 3: holding the object
; This is also state 3 for bombs.
@state3:
	call @deleteAndRetIfSwimmingOrGrabState0		; $51f7
	ld a,(wLinkInAir)		; $51fa
	rlca			; $51fd
	ret c			; $51fe
	ld a,($cc67)		; $51ff
	or a			; $5202
	ret nz			; $5203
	ld a,(w1Link.var2a)		; $5204
	or a			; $5207
	jr nz,++		; $5208

	ld a,(wGameKeysJustPressed)		; $520a
	and BTN_A|BTN_B			; $520d
	ret z			; $520f

	call updateLinkDirectionFromAngle		; $5210
++
	; Item is being thrown

	; Unlink related object from Link, set its "state2" to $02 (meaning just thrown)
	ld hl,w1Link.relatedObj2		; $5213
	xor a			; $5216
	ld c,(hl)		; $5217
	ldi (hl),a		; $5218
	ld b,(hl)		; $5219
	ldi (hl),a		; $521a
	ld a,c			; $521b
	add Object.state2			; $521c
	ld l,a			; $521e
	ld h,b			; $521f
	ld (hl),$02		; $5220

	; If it was a tile that was picked up, don't create any new objects
	ld e,Item.var37		; $5222
	ld a,(de)		; $5224
	or a			; $5225
	jr nz,@@throwItem	; $5226

	; If this is referencing an item object beyond index $d7, don't create object $dc
	ld a,c			; $5228
	cpa Item.start			; $5229
	jr nz,@@createPlaceholder	; $522a
	ld a,b			; $522c
	cp FIRST_DYNAMIC_ITEM_INDEX			; $522d
	jr nc,@@throwItem	; $522f

	; Create an invisible bracelet object to be used for collisions?
	; This is used when throwing dimitri, but not for picked-up tiles.
@@createPlaceholder:
	push de			; $5231
	ld hl,w1ReservedItemC.enabled		; $5232
	inc (hl)		; $5235
	inc l			; $5236
	ld a,ITEMID_BRACELET		; $5237
	ldi (hl),a		; $5239

	; Copy over this parent item's former relatedObj2 & Y/X to the new "physical" item
	ld l,Item.relatedObj2		; $523a
	ld a,c			; $523c
	ldi (hl),a		; $523d
	ld (hl),b		; $523e
	add Item.yh			; $523f
	ld e,a			; $5241
	ld d,b			; $5242
	call objectCopyPosition_rawAddress		; $5243
	pop de			; $5246

@@throwItem:
	ld a,(wLinkAngle)		; $5247
	rlca			; $524a
	jr c,+			; $524b
	ld a,(w1Link.direction)		; $524d
	swap a			; $5250
	rrca			; $5252
+
	ld l,Item.angle		; $5253
	ld (hl),a		; $5255
	ld l,Item.var38		; $5256
	ld a,(wLinkGrabState2)		; $5258
	ld (hl),a		; $525b
	xor a			; $525c
	ld (wLinkGrabState2),a		; $525d
	ld (wLinkGrabState),a		; $5260
	ld h,d			; $5263
	ld l,Item.state		; $5264
	inc (hl)		; $5266
	ld l,Item.var3f		; $5267
	ld (hl),$0f		; $5269

	; Load animation depending on whether Link's riding a minecart
	ld c,LINK_ANIM_MODE_THROW		; $526b
	ld a,(w1Companion.id)		; $526d
	cp SPECIALOBJECTID_MINECART			; $5270
	jr nz,+			; $5272
	ld a,(wLinkObjectIndex)		; $5274
	rrca			; $5277
	jr nc,+			; $5278
	ld c,LINK_ANIM_MODE_25		; $527a
+
	ld a,c			; $527c
	call specialObjectSetAnimationWithLinkData		; $527d
	call _itemDisableLinkMovement		; $5280
	call _itemDisableLinkTurning		; $5283
	ld a,SND_THROW		; $5286
	jp playSound		; $5288


; State 4: Link in throwing animation.
; This is also state 4 for bombs.
@state4:
	ld e,Item.animParameter		; $528b
	ld a,(de)		; $528d
	rlca			; $528e
	jp nc,_specialObjectAnimate		; $528f
	jr @dropAndDeleteSelf		; $5292

;;
; @addr{5294}
@deleteAndRetIfSwimmingOrGrabState0:
	ld a,(wLinkSwimmingState)		; $5294
	or a			; $5297
	jr nz,+			; $5298
	ld a,(wLinkGrabState)		; $529a
	or a			; $529d
	ret nz			; $529e
+
	pop af			; $529f

@dropAndDeleteSelf:
	call dropLinkHeldItem		; $52a0
	jp _clearParentItem		; $52a3

;;
; @param[out]	bc	Y/X of tile Link is grabbing
; @param[out]	zflag	Set if Link is directly facing a wall
; @addr{52a6}
@checkWallInFrontOfLink:
	ld a,(w1Link.direction)		; $52a6
	ld b,a			; $52a9
	add a			; $52aa
	add b			; $52ab
	ld hl,@@data		; $52ac
	rst_addAToHl			; $52af
	ld a,(w1Link.adjacentWallsBitset)		; $52b0
	and (hl)		; $52b3
	cp (hl)			; $52b4
	ret nz			; $52b5

	inc hl			; $52b6
	ld a,(w1Link.yh)		; $52b7
	add (hl)		; $52ba
	ld b,a			; $52bb
	inc hl			; $52bc
	ld a,(w1Link.xh)		; $52bd
	add (hl)		; $52c0
	ld c,a			; $52c1
	xor a			; $52c2
	ret			; $52c3

; b0: bits in w1Link.adjacentWallsBitset that should be set
; b1/b2: Y/X offsets from Link's position
@@data:
	.db $c0 $fb $00 ; DIR_UP
	.db $03 $00 $07 ; DIR_RIGHT
	.db $30 $07 $00 ; DIR_DOWN
	.db $0c $00 $f8 ; DIR_LEFT


; State 5: pulling a lever?
@state5:
	call _parentItemCheckButtonPressed	; $52d0
	jp z,@dropAndDeleteSelf		; $52d3
	call @deleteAndRetIfSwimmingOrGrabState0		; $52d6
	ld a,(w1Link.knockbackCounter)		; $52d9
	or a			; $52dc
	jp nz,@dropAndDeleteSelf		; $52dd

	ld a,(w1Link.direction)		; $52e0
	ld hl,@counterDirections		; $52e3
	rst_addAToHl			; $52e6
	ld a,(wGameKeysPressed)		; $52e7
	and (hl)		; $52ea
	ld a,LINK_ANIM_MODE_LIFT_2		; $52eb
	jp z,specialObjectSetAnimationWithLinkData		; $52ed
	jp _specialObjectAnimate		; $52f0


;;
; ITEMID_FEATHER ($17)
; @addr{52f3}
_parentItemCode_feather:
	ld e,Item.state		; $52f3
	ld a,(de)		; $52f5
	rst_jumpTable			; $52f6
	.dw @state0
	.dw @state1

@state0:

.ifdef ROM_AGES
	call _isLinkUnderwater		; $52fb
	jr nz,@deleteParent	; $52fe

	; Can't use the feather while using the switch hook
	ld a,(w1ParentItem2.id)		; $5300
	cp ITEMID_SWITCH_HOOK			; $5303
	jr z,@deleteParent	; $5305
.endif

	; No jumping in minecarts / on companions
	ld a,(wLinkObjectIndex)		; $5307
	rrca			; $530a
	jr c,@deleteParent	; $530b

	; No jumping when holding something?
	ld a,(wLinkGrabState)		; $530d
	or a			; $5310
	jr nz,@deleteParent	; $5311

	call _isLinkInHole		; $5313
	jr c,@deleteParent	; $5316

	ld hl,wLinkSwimmingState		; $5318
	ldi a,(hl)		; $531b
	; Check wcc5e as well
	or (hl)			; $531c
	jr nz,@deleteParent	; $531d

	ld a,(wLinkInAir)		; $531f
	add a			; $5322
	jr c,@deleteParent	; $5323

	add a			; $5325
	jr c,@state1		; $5326
	jr nz,@deleteParent	; $5328

	ld a,(w1Link.zh)		; $532a
	or a			; $532d
	jr nz,@deleteParent	; $532e

	; Jump higher in sidescrolling rooms
	ld bc,$fe20		; $5330
	ld a,(wActiveGroup)		; $5333
	cp $06			; $5336
	jr c,+			; $5338
	ld bc,$fdd0		; $533a
+
	ld hl,w1Link.speedZ		; $533d
	ld (hl),c		; $5340
	inc l			; $5341
	ld (hl),b		; $5342

	ld a,$01		; $5343

.ifdef ROM_SEASONS
	ld a,(wFeatherLevel)
	cp $02
	ld a,$41
	jr z,++
.endif
	ld a,$01		; $5183
++
	ld (wLinkInAir),a		; $5347
	jr nz,@deleteParent	; $534a

	ld e,Item.state		; $534c
	ld a,$01		; $534e
	ld (de),a		; $5350
	ret			; $5351

@deleteParent:
	jp _clearParentItem		; $5352

@state1:

.ifdef ROM_AGES
	jp _clearParentItem		; $5355
.else
	ld a,(wLinkInAir)
	bit 5,a
	jr nz,@deleteParent

	call _parentItemCheckButtonPressed
	jr z,@deleteParent

	ld hl,w1Link.speedZ
	ldi a,(hl)
	ld h,(hl)
	bit 7,h
	ret nz

	ld l,a
	ld bc,$0100
	call compareHlToBc
	inc a
	ret z

	ld hl,w1Link.speedZ
	ld (hl),<(-$80)
	inc l
	ld (hl),>(-$80)

	push de
	ld d,h
	ld a,LINK_ANIM_MODE_ROCS_CAPE
	call specialObjectSetAnimation
	pop de
	ld hl,wLinkInAir
	set 5,(hl)
	ld a,SND_THROW
	call playSound
	jp _clearParentItem
.endif


;;
; ITEMID_MAGNET_GLOVES ($08)
; @addr{5358}
_parentItemCode_magnetGloves:
	call _checkNoOtherParentItemsInUse		; $5358
--
	push hl			; $535b
	call nz,_clearParentItemH		; $535c
	pop hl			; $535f
	call _checkNoOtherParentItemsInUse@nextItem		; $5360
	jr nz,--		; $5363
	ret			; $5365
