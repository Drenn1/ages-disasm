; The first $c interactions consist of various animations.
; SubID:
;  Bit 0 - flicker to create transparency
;  Bit 7 - disable sound effect
.define INTERACID_GRASSDEBRIS		$00
.define INTERACID_REDGRASSDEBRIS	$01
.define INTERACID_GREENPOOF		$02
.define INTERACID_SPLASH		$03
.define INTERACID_LAVASPLASH		$04
.define INTERACID_PUFF		$05
.define INTERACID_ROCKDEBRIS		$06
.define INTERACID_CLINK		$07
.define INTERACID_KILLENEMYPUFF	$08
.define INTERACID_SNOWDEBRIS		$09
.define INTERACID_SHOVELDEBRIS	$0a
.define INTERACID_0B			$0b
.define INTERACID_ROCKDEBRIS2		$0c

; SubID: 
;  Bit 7 - disable sound effect
.define INTERACID_FALLDOWNHOLE	$0f

.define INTERACID_FARORE		$10
; SubID: xy
;  y=0: "Parent" interaction
;  y=1: "Children" sparkles
;  x: for y=1, this sets the sparkle's initial moving direction
.define INTERACID_FARORE_MAKEITEM	$11

; SubID:
;  00: Show text on entering dungeon
;  01: Small key falls when wNumEnemies == 0
;  02:
;  03:
;  04:
.define INTERACID_DUNGEON_STUFF	$12

; This interaction is created at $d140 (w1ReservedInteraction1) when a block/pot/etc is
; pushed.
.define INTERACID_PUSH_BLOCK		$14

.define INTERACID_MINECART	$16

.define INTERACID_CLOSING_DOOR	$1e

.define INTERACID_TREASURE		$60

.define INTERACID_84			$84
.define INTERACID_90			$90

; SubID: a unique value from $0-$f used as an index for wGashaSpot variables
.define INTERACID_GASHA_SPOT		$b6

.define INTERACID_BB			$bb
.define INTERACID_PIRATE_SHIP		$c2
