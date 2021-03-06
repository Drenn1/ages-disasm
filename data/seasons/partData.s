; Data format:
; b0: object gfx index (see data/objectGfxHeaders.s)
; b1: Part.enemyCollisionMode (bit 7 must be set for collisions to work)
; b2: Part.collisionRadiusY/X
; b3: Part.damage
; b4: Part.health
; b5: Part.oamTileIndexBase
; b6: Part.oamFlags
; b7: nothing

partData:
	.db $00 $00 $00 $00 $40 $0c $03 $00 ; $00
	.db $5c $01 $44 $00 $01 $00 $08 $00 ; $01
	.db $00 $00 $00 $00 $40 $0c $0a $00 ; $02
	.db $53 $83 $44 $00 $40 $1e $00 $00 ; $03
	.db $00 $00 $00 $00 $40 $0c $0a $00 ; $04
	.db $00 $83 $44 $ff $40 $08 $00 $00 ; $05
	.db $00 $82 $44 $ff $40 $00 $00 $00 ; $06
	.db $8f $00 $00 $00 $40 $00 $00 $00 ; $07
	.db $00 $00 $00 $00 $40 $00 $00 $00 ; $08
	.db $00 $02 $22 $00 $40 $00 $00 $00 ; $09
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; $0a
	.db $53 $83 $44 $00 $40 $1e $00 $00 ; $0b
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; $0c
	.db $72 $82 $66 $00 $40 $1e $00 $00 ; $0d
	.db $00 $02 $22 $00 $01 $00 $08 $00 ; $0e
	.db $00 $82 $33 $00 $40 $00 $00 $00 ; $0f
	.db $5c $81 $33 $00 $01 $00 $00 $00 ; $10
	.db $00 $04 $22 $fe $01 $02 $0a $00 ; $11
	.db $00 $00 $00 $00 $01 $08 $0a $00 ; $12
	.db $59 $82 $77 $00 $40 $0a $01 $00 ; $13
	.db $5c $01 $32 $00 $01 $00 $08 $00 ; $14
	.db $5d $01 $32 $00 $01 $00 $08 $00 ; $15
	.db $09 $82 $ca $00 $01 $00 $01 $00 ; $16
	.db $00 $82 $00 $00 $40 $00 $00 $00 ; $17
	.db $74 $87 $22 $fc $40 $0c $03 $00 ; $18
	.db $00 $87 $22 $fc $40 $1c $0a $00 ; $19
	.db $73 $86 $22 $fc $40 $00 $02 $00 ; $1a
	.db $7a $e6 $22 $fa $40 $1a $05 $00 ; $1b
	.db $82 $86 $22 $fc $40 $0a $02 $00 ; $1c
	.db $00 $e7 $11 $fc $40 $00 $00 $00 ; $1d
	.db $71 $86 $21 $fc $40 $18 $05 $00 ; $1e
	.db $86 $86 $55 $fa $40 $0a $00 $00 ; $1f
	.db $00 $e8 $55 $fc $40 $08 $0a $00 ; $20
	.db $73 $86 $22 $fc $40 $0a $04 $00 ; $21
	.db $3f $e8 $66 $f8 $40 $00 $02 $00 ; $22
	.db $00 $69 $55 $f8 $40 $0a $0a $00 ; $23
	.db $a7 $06 $22 $fc $40 $18 $02 $00 ; $24
	.db $00 $00 $00 $00 $40 $00 $00 $00 ; $25
	.db $00 $ea $00 $f4 $40 $06 $0a $00 ; $26
	.db $8e $04 $00 $f8 $40 $0e $04 $00 ; $27
	.db $5c $81 $44 $00 $01 $00 $02 $00 ; $28
	.db $8f $87 $33 $fc $40 $08 $04 $00 ; $29
	.db $7f $6b $66 $fc $40 $08 $02 $00 ; $2a
	.db $00 $82 $f0 $ff $40 $00 $00 $00 ; $2b
	.db $57 $00 $00 $00 $40 $12 $04 $00 ; $2c
	.db $52 $82 $cc $00 $08 $10 $05 $00 ; $2d
	.db $8f $00 $66 $00 $40 $18 $04 $00 ; $2e
	.db $00 $84 $74 $fe $40 $00 $00 $00 ; $2f
	.db $5c $00 $00 $00 $01 $02 $05 $00 ; $30
	.db $00 $86 $22 $fc $40 $1c $0a $00 ; $31
	.db $38 $f2 $22 $00 $01 $02 $01 $00 ; $32
	.db $6e $86 $54 $fa $40 $00 $04 $00 ; $33
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; $34
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; $35
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; $36
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; $37
	.db $73 $86 $22 $fc $01 $0a $05 $00 ; $38
	.db $73 $06 $66 $fc $01 $14 $05 $00 ; $39
	.db $73 $f1 $33 $fc $01 $16 $04 $00 ; $3a
	.db $00 $67 $00 $fc $01 $00 $00 $00 ; $3b
	.db $00 $ec $22 $fc $01 $06 $0a $00 ; $3c
	.db $a1 $86 $22 $fc $01 $08 $05 $00 ; $3d
	.db $a2 $06 $22 $fc $01 $00 $04 $00 ; $3e
	.db $93 $6d $66 $f8 $01 $04 $01 $00 ; $3f
	.db $a7 $86 $22 $fc $01 $18 $02 $00 ; $40
	.db $8f $86 $22 $fc $01 $12 $02 $00 ; $41
	.db $73 $86 $22 $fc $01 $0e $05 $00 ; $42
	.db $90 $86 $55 $fc $40 $02 $02 $00 ; $43
	.db $73 $83 $44 $00 $40 $18 $01 $00 ; $44
	.db $bc $06 $66 $f8 $40 $18 $04 $00 ; $45
	.db $00 $06 $22 $f8 $40 $1c $0a $00 ; $46
	.db $be $58 $88 $fc $40 $14 $01 $00 ; $47
	.db $7b $06 $66 $f8 $40 $00 $05 $00 ; $48
	.db $00 $84 $66 $f8 $01 $28 $09 $00 ; $49
	.db $73 $86 $66 $fa $40 $18 $02 $00 ; $4a
	.db $84 $6e $44 $f8 $40 $10 $05 $00 ; $4b
	.db $84 $86 $63 $fc $40 $14 $02 $00 ; $4c
	.db $c5 $6e $44 $f8 $40 $00 $04 $00 ; $4d
	.db $c5 $06 $66 $fc $40 $02 $01 $00 ; $4e
	.db $15 $6f $86 $00 $01 $00 $04 $00 ; $4f
	.db $1d $f0 $6c $f4 $40 $00 $01 $00 ; $50
	.db $1c $86 $aa $f0 $40 $00 $02 $00 ; $51
	.db $1c $86 $55 $f8 $40 $0e $05 $00 ; $52
	.db $6b $00 $00 $00 $40 $00 $04 $00 ; $53
