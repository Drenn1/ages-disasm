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
;  x: for y=1, this sets the sparkle's initial angle
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

; This shows a key or boss key sprite when opening a door.
; SubID is the tile index of the door being opened.
.define INTERACID_DUNGEON_KEY_SPRITE	$17

; This is used when opening keyholes in the overworld.
; SubID is the questItem index of the key being used, minus $42 (QUESTITEM_GRAVEYARD_KEY,
; the first one).
.define INTERACID_OVERWORLD_KEY_SPRITE	$18

; This works as both a door opener and closer.
.define INTERACID_CLOSING_DOOR	$1e

.define INTERACID_TREASURE		$60

.define INTERACID_84			$84
.define INTERACID_90			$90

; Bubbles created at random when swimming in a sidescrolling area
.define INTERACID_BUBBLE		$91

.define INTERACID_EXCLAMATION_MARK	$9f

; SubID: a unique value from $0-$f used as an index for wGashaSpot variables
.define INTERACID_GASHA_SPOT		$b6

.define INTERACID_BB			$bb
.define INTERACID_PIRATE_SHIP		$c2

; The warp animation that occurs when entering a time portal.
; SubID: 0: Initiating a warp (entered a portal from the source screen)
;        1: Completing a warp (warping in to the destination screen)
.define INTERACID_TIMEWARP		$dd

; A time portal created with the Tune of Currents or Tune of Ages.
.define INTERACID_TIMEPORTAL		$de

; Creates a time portal when the Tune of Echoes is played.
.define INTERACID_TIMEPORTAL_SPAWNER	$e1
