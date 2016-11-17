.STRUCT GfxRegsStruct
	LCDC	db
	SCY	db
	SCX	db
	WINY	db
	WINX	db
	LYC	db
.ENDST
.define GfxRegsStruct.size 6

.STRUCT DeathRespawnStruct
	group		db
	room		db
	stateModifier	db
	facingDir	db
	y		db
	x		db
	cc24		db
	cc25		db
	cc26		db
	linkObjectIndex	db
	cc27		db
	cc28		db
.ENDST
.define DeathRespawnStruct.size $0c

.STRUCT FileDisplayStruct
	b0		db ; Bit 7 set if the file is blank
	b1		db
	numHearts	db
	numHeartContainers	db
	deathCountL	db
	deathCountH	db
	b6		db ; Bit 0: linked game
	b7		db ; Bit 0: completed game, 1: hero's file
.ENDST
.define FileDisplayStruct.size 8

; ========================================================================================
; Object structures
; ========================================================================================

; Definitions which can apply to any kind of object
.STRUCT ObjectStruct
	enabled			db ; $00
	id			db ; $01
	subid			db ; $02
	var03			db ; $03
	state			db ; $04
	state2			db ; $05
	counter1		db ; $06
	counter2		db ; $07
	direction		db ; $08
	angle			db ; $09
	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f
	speed			db ; $10
	speedTmp		db ; $11
	var12			db ; $12
	var13			db ; $13
	speedZ			dw ; $14
	relatedObj1		dw ; $16
	relatedObj2		dw ; $18

	; Bit 7 of visible tells if it's visible, bits 0-1 determine its priority, bit
	; 6 is set if the object has terrain effects (shadow, puddle/grass animation)
	visible			db ; $1a

	; oamFlagsBackup generally never changes, so it's used to remember what flags the
	; object should have "normally" (ie. when it's not flashing from damage).
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c

	oamTileIndexBase	db ; $1d
	oamDataAddress		dw ; $1e
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24: bit 7: set to enable collisions (for Enemies, Parts)
	collisionReactionSet	db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28
	health			db ; $29

	; bit 7: set to disable collisions (for Enemies, Parts)
	; bit 5: set on collision with an object?
	var2a			db ; $2a

	; When this is $00-$7f, this counts down and the object flashes red.
	; When this is $80-$ff, this counts up and the object is just invincible.
	invincibilityCounter	db ; $2b

	knockbackAngle		db ; $2c
	knockbackCounter	db ; $2d
	stunCounter		db ; $2e: if nonzero, enemies / parts don't damage link
	var2f			db ; $2f
	var30			db ; $30
	var31			db ; $31
	var32			db ; $32
	var33			db ; $33
	var34			db ; $34
	var35			db ; $35
	var36			db ; $36
	var37			db ; $37
	var38			db ; $38
	var39			db ; $39
	var3a			db ; $3a
	var3b			db ; $3b
	var3c			db ; $3c
	var3d			db ; $3d
	var3e			db ; $3e
	var3f			db ; $3f
.ENDST

; Special objects like link, companions
.STRUCT SpecialObjectStruct
	enabled			db ; $00
	id			db ; $01
	subid			db ; $02
	var03			db ; $03
	state			db ; $04
	state2			db ; $05

	; Link's counter1 is used for:
	;  - Movement with flippers
	;  - Recovering from stone & collapsed states
	counter1		db ; $06

	; Link's counter2 is used for:
	; - Creating bubbles in sidescrolling underwater areas
	; - Diving underwater
	counter2		db ; $07

	direction		db ; $08
	angle			db ; $09
	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f
	speed			db ; $10
	speedTmp		db ; $11

	; This might be another speed variable?
	var12			db ; $12

	var13			db ; $13
	speedZ			dw ; $14
	relatedObj1		dw ; $16

	; relatedObj2 uses for link:
	; - switch hook
	; - shop items (held items in general?)
	relatedObj2		dw ; $18

	visible			db ; $1a
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c
	oamTileIndexBase	db ; $1d
	oamDataAddress		db ; $1e
	var1f			db ; $1f
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24
	damageToApply		db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28

	; Link uses this "health" variable instead as a sort of "damage reduction"
	; variable; this is probably so that damage that would be 1/8th of a heart rounds
	; down instead of up.
	health			db ; $29

	var2a			db ; $2a
	invincibilityCounter	db ; $2b
	knockbackAngle		db ; $2c
	knockbackCounter	db ; $2d
	stunCounter		db ; $2e

	; Bit 7 set if Link is underwater?
	; Bit 6 set if Link is wearing the mermaid suit? (even on land)
	var2f			db ; $2f

	animMode		db ; $30
	var31			db ; $31

	; Graphics index?
	var32			db ; $32

	; For link, this has certain bits set depending on where walls are on any side of
	; him?
	adjacentWallsBitset	db ; $33

	; Bit 4 set if Link is pushing against a wall?
	var34			db ; $34

	; Keeps track of when you press "A" to swim faster in water (for flippers).
	; $00 normally, $01 when speeding up, $02 when speeding down.
	var35			db ; $35

	; For link, this is an index for a table in the updateLinkSpeed function?
	var36			db ; $36

	var37			db ; $37
	var38			db ; $38
	var39			db ; $39
	var3a			db ; $3a
	var3b			db ; $3b
	var3c			db ; $3c
	var3d			db ; $3d
	var3e			db ; $3e
	var3f			db ; $3f
.ENDST

.STRUCT ItemStruct
	enabled			db ; $00
	id			db ; $01
	subid			db ; $02
	var03			db ; $03
	state			db ; $04

	; For items, this is used as a "being held" state.
	; $00: Just picked up?
	; $01: Being held
	; $02: Just released?
	; $03: Not being held
	state2			db ; $05

	counter1		db ; $06
	counter2		db ; $07
	direction		db ; $08
	angle			db ; $09
	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f
	speed			db ; $10
	speedTmp		db ; $11
	var12			db ; $12
	var13			db ; $13
	speedZ			dw ; $14
	relatedObj1		dw ; $16

	; relatedObj2 uses for link:
	; - switch hook
	; - shop items
	relatedObj2		dw ; $18

	visible			db ; $1a
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c
	oamTileIndexBase	db ; $1d
	oamDataAddress		db ; $1e
	var1f			db ; $1f
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24
	damageToApply		db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28
	health			db ; $29
	var2a			db ; $2a
	invincibilityCounter	db ; $2b
	knockbackAngle		db ; $2c
	knockbackCounter	db ; $2d
	stunCounter		db ; $2e
	var2f			db ; $2f
	var30			db ; $30
	var31			db ; $31
	var32			db ; $32
	var33			db ; $33
	var34			db ; $34
	var35			db ; $35
	var36			db ; $36
	var37			db ; $37
	var38			db ; $38
	var39			db ; $39
	var3a			db ; $3a
	var3b			db ; $3b
	var3c			db ; $3c
	var3d			db ; $3d

	; keeps track of the elevation of the item, for passing through cliff tiles
	var3e			db ; $3e

	var3f			db ; $3f
.ENDST

; Interactions (npcs, etc)
.STRUCT InteractionStruct
	enabled			db ; $00
	id			db ; $01
	subid			db ; $02
	var03			db ; $03
	state			db ; $04
	state2			db ; $05
	; counter1 is used by the checkabutton command among others. checkabutton
	; doesn't activate until it reaches zero.
	counter1		db ; $06
	counter2		db ; $07
	direction		db ; $08
	angle			db ; $09
	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f
	speed			db ; $10
	speedTmp		db ; $11
	var12			db ; $12
	var13			db ; $13
	speedZ			dw ; $14
	relatedObj1		dw ; $16
	relatedObj2		dw ; $18
	visible			db ; $1a
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c
	oamTileIndexBase	db ; $1d
	oamDataAddress		dw ; $1e
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24
	collisionReactionSet	db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28
	health			db ; $29
	var2a			db ; $2a
	invincibilityCounter	db ; $2b
	knockbackAngle		db ; $2c
	knockbackCounter	db ; $2d
	stunCounter		db ; $2e
	var2f			db ; $2f
	; If nonzero, Interaction.textID+1 ($33) replaces whatever upper byte you use in a showText opcode.
	useTextID		db ; $30

	pressedAButton		db ; $31
	textID			dw ; $32
	var34			db ; $34
	scriptRet		db ; $35
	var36			db ; $36
	var37			db ; $37
	var38			db ; $38
	var39			db ; $39
	var3a			db ; $3a
	var3b			db ; $3b
	var3c			db ; $3c
	var3d			db ; $3d
	var3e			db ; $3e
	var3f			db ; $3f
.ENDST

; TODO: make these part of the structs, properly (wla needs fixes for this?)
.define Item.start	$00

.define Interaction.start	$40
.define Interaction.scriptPtr	$58
.define Interaction.var30	$70
.define Interaction.var31	$71
.define Interaction.var32	$72
.define Interaction.var33	$73
.define Interaction.var35	$75

.define Enemy.start	$80

.define Part.start	$c0

.define w1Link.warpVar1 $d005
.define w1Link.warpVar2 $d006


.enum $00
	Object		instanceof ObjectStruct
.ende

.enum $00
	SpecialObject	instanceof SpecialObjectStruct
.ende

.enum $00
	Item		instanceof ItemStruct
.ende

.enum $40
	Interaction	instanceof InteractionStruct
.ende

; Enemys/Parts not unique enough to need their own sets of variables (yet)
.enum $80
	Enemy		instanceof ObjectStruct
.ende

.enum $c0
	Part		instanceof ObjectStruct
.ende
