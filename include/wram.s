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
	numHeartsContainers	db
	deathCountL	db
	deathCountH	db
	b6		db ; Bit 0: linked game
	b7		db ; Bit 0: completed game, 1: hero's file
.ENDST
.define FileDisplayStruct.size 8


.define wMusicReadFunction $c000

; Used within the music playing functions
.define wLoadingSoundBank $c017
; Initially used as the index of the sound to play
.define wSoundChannel $c018
.define wSoundChannelValue $c019
.define wSoundChannel2 $c01a

.define wSoundCmd	$c01d
; This value goes straight to NR12/NR22
; In some situations it is also used to mark whether to reset / use the counter
; for the channel (NRx4)
.define wSoundCmdEnvelope $c01e

.define wSoundFrequencyL $c01f
.define wSoundFrequencyH $c020

.define wWaveformIndex $c021
.define wWaveChannelVolume $c022

; This value goes straight to NR50.
; Bits 0-2: left speaker, 4-6: right speaker (unless I mixed them up)
.define wSoundVolume	$c024

.define wC025 $c025
.define wC02d $c02d

; An offset for wSoundFrequencyL,H
.define wChannelPitchShift $c033

; c039 might be related to the "counter" bit (NRx4)
.define wC039 $c039

; c03f might be related to sweep
.define wC03f $c03f

.define wC045 $c045
.define wChannelVibratos $c04b
.define wC051 $c051
.define wChannelDutyCycles $c057

.define wC05d $c05d
.define wC061 $c061
.define wChannelEnvelopes $c065
.define wChannelEnvelopes2 $c069
; $8 bytes each
.define wChannelsEnabled $c06d
.define wChannelWaitCounters $c075
.define wChannelVolumes $c07d

; $10 bytes
.define wMusicQueue $c0a0

.define wMainStackTop $c110
.define wThread0StackTop $c180
.define wThread1StackTop $c220
.define wThread2StackTop $c270
.define wThread3StackTop $c2c0

; $20 byte buffer (with a few 2-byte gaps)
.define wThreadStateBuffer $c2e0

.define NUM_THREADS	4

; Used for the intro
.define THREAD_0	<wThreadStateBuffer + 0*8
; Used for main game, file select screen
.define THREAD_1	<wThreadStateBuffer + 1*8
; Used for displaying text
.define THREAD_2	<wThreadStateBuffer + 2*8
; Used for handling palette fadeouts (basically always on?)
.define THREAD_3	<wThreadStateBuffer + 3*8

.define wIntroStage	wThreadStateBuffer + 6
.define wIntroVar	wThreadStateBuffer + 7

.define wC2ee		wThreadStateBuffer + $e
; Writing a value here triggers a cutscene.
.define wCutsceneIndex	$c2ef

.define wPaletteFadeCounter $c2ff

; General purpose $100 byte buffer (used for scripts, underwater waves maybe?)
.define wBigBuffer	$c300

; Dunno how big this buffer is
.define wVBlankFunctionQueue	$c400

.ENUM $c480
	wKeysPressedLastFrame: 	db ; c480
	wKeysPressed: 		db ; c481
	wKeysJustPressed: 	db ; c482
	wAutoFireKeysPressed: 	db ; c483
	wAutoFireCounter: 	db ; c484

; Note: wGfxRegs2 and wGfxRegs3 can't cross pages (say, c2xx->c3xx)
	wGfxRegs1:	INSTANCEOF GfxRegsStruct	; $c485
	wGfxRegs2:	INSTANCEOF GfxRegsStruct	; $c48b
	wGfxRegs3:	INSTANCEOF GfxRegsStruct	; $c491
	wGfxRegsFinal:	INSTANCEOF GfxRegsStruct	; $c497
.ENDE
; Enum end at $c49d

; Used by vblank wait loop
.define wVBlankChecker	$c49d

; There may be yet another GfxRegsStruct at c4a5

.define wPaletteFadeMode $c4ab
.define wPaletteFadeSpeed $c4ac
.define wC4ad		 $c4ad
.define wPaletteFadeState $c4ae
.define wC4af		 $c4af
.define wC4b0		 $c4b0
.define wPaletteFadeBG1	$c4b1
.define wPaletteFadeSP1	$c4b2
.define wPaletteFadeBG2	$c4b3
.define wPaletteFadeSP2	$c4b4
.define wC4b5		$c4b5
.define wC4b6		$c4b6

; This is just a jp opcode afaik
.define wRamFunction	$c4b7

; This is a pointer to the oam data for the animation when you stand in
; a puddle. Updated every 16 frames.
.define wPuddleAnimationPointer	$c4ba

; This might only be used for drawing objects' shadows, though in theory it
; could also be used to draw puddles and grass as objects walk over them.
; Each entry is 4 bytes: Y, X, and an address in the "Special_Animations"
; section (bank $14).
.define wTerrainEffectsBuffer	$c4c0

; A $40 byte buffer keeping track of which objects to draw, in what order
; (first = highest priority). Each entry is 2 bytes, consisting of the address
; of high byte of the object's y-position.
.define wObjectsToDraw	$c500

; $40 bytes
.define wUnappraisedRings	$c5c0

; ==========================================================================================
; C6xx block: deals largely with inventory, also global flags
; ==========================================================================================

.define wC600Block $c600

; $c600-c615 treated as a block in at least one place (game link)

; 6 bytes, null terminated
.define wLinkName		$c602
; $c608 ?
.define wKidName		$c609
; $c60f ?

; $0b for ricky, $0c for dimitri, $0d for moosh
.define wAnimalRegion		$c610
; Copied to wIsLinkedGame
.define wFileIsLinkedGame	$c612

.define wC614			$c614

; 8 bytes
.define wRingsObtained		$c616

; 4 bytes
.define wPlaytimeCounter $c622

.define wNumSignsDestroyed $c626

.define wTextSpeed	$c629
.define wActiveLanguage $c62a ; Doesn't do anything on the US version

.enum $c62b

; $0c bytes
wDeathRespawnBuffer:	INSTANCEOF DeathRespawnStruct

.ende
; Ends at $c638

; Looks like a component is set to $10 or $70 if the animal enters from
; a particular side.
.define wAnimalEntryY	$c638
.define wAnimalEntryX	$c639

; Like wActiveGroup and wActiveRoom, but for the minimap. Not updated in caves.
.define wMinimapGroup $c63a
.define wMinimapRoom $c63b

.define wPortalGroup	$c63e
.define wPortalRoom	$c63f
.define wPortalPos	$c640
.define wMapleKillCounter $c641

; Lower 4 bits mark the items bought from the hidden shop
.define wHiddenShopItemsBought	$c642

; 2 bytes
.define wGashaSpotsPlantedBitset $c64d
; 16 bytes
.define wGashaSpotKillCounters $c64f

; Global flags (like for ricky sidequest) around $c640
; At least I know $c646 is a global flag

; 1 byte per dungeon. Each byte is a bitset of visited floors for a particular dungeon.
.define wDungeonVisitedFloors		$c662

; 1 byte per dungeon. Uses $10 bytes max
.define wDungeonSmallKeys	$c672

; Bitset of compasses obtained?
.define wCompassFlags		$c684

.define wInventoryB	$c688
.define wInventoryA	$c689
; $10 bytes
.define wInventoryStorage	$c68a

; Consider renaming to secondaryItemsObtained or something
.define wQuestItemFlags	$c69a
; Ends at $c6a5
.define wSeedsAndHarpSongsObtained	$c69e

.define wLinkHealth	$c6aa
.define wLinkNumHearts	$c6ab
.define wNumHeartPieces	$c6ac
.define wNumRupees	$c6ad

.define wShieldLevel	$c6af
.define wNumBombs	$c6b0

.define wSwordLevel		$c6b2
.define wNumBombchus		$c6b3
.define wFluteIcon		$c6b5
.define wSwitchHookLevel	$c6b6
.define wSelectedHarpSong	$c6b7
.define wBraceletLevel		$c6b8
.define wNumEmberSeeds		$c6b9
.define wNumScentSeeds		$c6ba
.define wNumPegasusSeeds	$c6bb
.define wNumGaleSeeds		$c6bc
.define wNumMysterySeeds	$c6bd
.define wNumGashaSeeds		$c6be
.define wEssencesObtained	$c6bf

.define wC6c0			$c6c0
.define wC6c2			$c6c2
.define wSatchelSelectedSeeds	$c6c4
.define wShooterSelectedSeeds	$c6c5
.define wRingBoxContents	$c6c6
.define wActiveRing		$c6cb
.define wRingBoxLevel		$c6cc
.define wNumUnappraisedRingsBcd	$c6cd

.define wGlobalFlags $c6d0

; This almost certainly does more than control the water level.
.define wJabuWaterLevel	$c6e9

.define wC6ed	$c6ed

; Flags shared for above water and underwater
.define wPresentRoomFlags $c700
.define wPastRoomFlags $c800

; Steal 6 of the past room flags for vine seed positions
.define wVinePositions $c8f0

.define wGroup4Flags	$c900
.define wGroup5Flags	$ca00

.define wOam $cb00
.define wOamEnd $cba0

; Nonzero if text is being displayed.
; If $80, text has finished displaying while TEXTBOXFLAG_NONEXITABLE is set.
.define wTextIsActive	$cba0

; $00: standard text
; $01: selecting an option
; $02: inventory screen
.define wTextDisplayMode $cba1 ; $02 for inventory screen, $00 for normal text

; Note that the text index is incremented by $400 before being written here.
; This is due to there being 4 dictionaries. Within text routines, this
; 4-higher value is used.
.define wTextIndex	$cba2
.define wTextIndexL	$cba2
.define wTextIndexH	$cba3
.define wTextIndexH_backup $cba4

; Selected option in a textbox, ie. yes/no
.define wSelectedTextOption $cba5

; What color text should be as it's read from the retrieveTextCharacter
; function. Values 0-2 set the text to those respective colors, while a value
; of 3 tells it to read in 2bpp format instead.
.define wTextGfxColorIndex $cba6

; Where the tile map is for the text (always $98?)
.define wTextMapAddress	$cba7

; 2-byte BCD number that can be inserted into text.
.define wTextNumberSubstitution $cba8

; cbaa/ab are similar to wTextNumberSubstitution, but possibly unused?

; Value from 0-6 determining the position of the textbox.
.define wTextboxPosition $cbac

.define wTextboxFlags	$cbae

; $cbaf-cbb2; each byte is an index which can be used with text control code
; $F, when the parameter is $ff, $fe, $fd, or $fc. The text corresponding to
; the index is inserted into the textbox at that point.
.define wTextSubstitutions $cbaf

; Used for a variety of purposes
; cbb3-cbc2 are sometimes cleared togother

.define wTmpCbb3		$cbb3
 .define wFileSelectMode	wTmpCbb3

.define wTmpCbb4		$cbb4
 .define wFileSelectMode2	wTmpCbb4
; Used for:
; - Index of link's position on map
; - Index of an interaction?
.define wTmpCbb5		$cbb5
 ; Selection in submenus (seeds, harp)
 .define wItemSubmenuIndex	wTmpCbb5

; Used for:
; - Index of cursor on map
; - Something in menus
.define wTmpCbb6	$cbb6

.define wTmpCbb7		$cbb7
 ; $00 for link name input, $01 for kid name input, $82 for secret input for new file
 .define wTextInputMode		wTmpCbb7
 .define wInventorySelectedItem	wTmpCbb7

.define wTmpCbb8		$cbb8
 .define wTextInputMaxCursorPos	wTmpCbb8

.define wTmpCbb9		$cbb9
 .define wInventorySubmenu2CursorPos2 wTmpCbb9

.define wTmpCbba		$cbba
 .define wFileSelectFontXor	wTmpCbba

.define wTmpCbbb			$cbbb
 .define wFileSelectCursorOffset	wTmpCbbb
 .define wInventoryActiveText		wTmpCbbb

.define wTmpCbbc		$cbbc
 .define wFileSelectCursorPos	wTmpCbbc

.define wTmpCbbd		$cbbd
 .define wFileSelectCursorPos2	wTmpCbbd

.define wTmpCbbe		$cbbe
 .define wTextInputCursorPos	wTmpCbbe
 .define wItemSubmenuCounter	wTmpCbbe

.define wTmpCbbf		$cbbf
 .define wItemSubmenuMaxWidth	wTmpCbbf
 .define wFileSelectLinkTimer	wTmpCbbf

.define wItemSubmenuWidth	$cbc0

.define wCbca		$cbca

; $01: inventory
; $02: map
; $03: save/quit menu
.define wOpenedMenuType		$cbcb

.define wMenuLoadState		$cbcc
.define wMenuActiveState	$cbcd
; State for item submenus (selecting seed satchel, shooter, or harp)
.define wItemSubmenuState	$cbce
; Value from 0-2, one for each submenu on the inventory screen
.define wInventorySubmenu	$cbcf

.define wInventorySubmenu0CursorPos	$cbd0
.define wInventorySubmenu1CursorPos	$cbd1
.define wInventorySubmenu2CursorPos	$cbd2

.ENUM $cbd5
	wGfxRegs4:	INSTANCEOF GfxRegsStruct	; $cbd5
	wGfxRegs5:	INSTANCEOF GfxRegsStruct	; $cbdb
.ENDE

; cbe1/2: screen scroll for menus?
; cbe3: palette header index for menus?

.define wDisplayedHearts	$cbe4
.define wDisplayedRupees	$cbe5 ; 2 bytes

; if nonzero, status bar doesn't get updated
.define wDontUpdateStatusBar	$cbe7

; Bit 7: whether status bar is reorganized for biggoron's sword maybe?
; Bit 0 set if status bar needs to be reorganized slightly for last row of hearts
.define wCbe8			$cbe8

; Bit 2: heart display needs refresh
; Bit 3: rupee count needs reflesh
; Bit 4: small key count
.define wStatusBarNeedsRefresh	$cbe9

.define wBItemSpriteAttribute1	$cbeb
.define wBItemSpriteAttribute2	$cbec
.define wBItemSpriteXOffset	$cbed

.define wAItemSpriteAttribute1	$cbf0
.define wAItemSpriteAttribute2	$cbf1
.define wAItemSpriteXOffset	$cbf2

; Value copied from low byte of wPlaytimeCounter
.define wFrameCounter	$cc00
.define wIsLinkedGame	$cc01
.define wMenuDisabled	$cc02

; An index for wLoadedNpcGfx. Keeps track of where to add the next thing to be
; loaded?
.define wLoadedNpcGfxIndex	$cc06

; This is a data structure related to used sprites. Each entry is 2 bytes, and
; corresponds to an npc gfx header loaded into vram at its corresponding
; position.
; Eg. Entry $cc08/09 is loaded at $8000, $cc0a/0b is loaded at $8200.
; Byte 0 is the index of the npc header (see npcGfxHeaders.s).
; Byte 1 is whether these graphics are currently in use?
.define wLoadedNpcGfx		$cc08
.define wLoadedNpcGfxEnd	$cc18

; This is the same structure as the above buffer, but only for trees.
.define wLoadedTreeGfxIndex	$cc18
.define wLoadedTreeGfxActive	$cc19

; cc1b/cc1c: values written here are treated as uncompressed gfx header indices

; Point to respawn after falling in hole or w/e
.define wLinkLocalRespawnY	$cc21
.define wLinkLocalRespawnX	$cc22
.define wLinkLocalRespawnDir	$cc23
.define wCc24			$cc24
.define wCc25			$cc25
.define wCc26			$cc26
.define wCc27			$cc27
.define wCc28			$cc28

; Always $d0?
.define wLinkObjectIndex $cc2c

.define wActiveGroup	$cc2d

; $00 for normal-size rooms, $01 for large rooms
.define wRoomIsLarge	$cc2e

.define wLoadingRoom      $cc2f
.define wActiveRoom       $cc30
.define wRoomPack		$cc31
; Can have values from 00-02: incremented by 1 when underwater, and when map flag 0 is set
; Used by interaction 0 for conditional interactions
.define wRoomStateModifier $cc32
; wActiveCollisions should be a value from 0-5.
; 0: overworld, 1: indoors, 2: dungeons, 3: sidescrolling, 4: underwater, 5?
.define wActiveCollisions $cc33
.define wAreaFlags	$cc34

; Don't know what the distinction for the 2 activeMusic's is
.define wActiveMusic     $cc35

; Change the color of the animation when objects walk in the grass. Unused in
; ages - it's meant to match the season.
; Valid values: $00 (green), $09 (blue), $1b (orange)
.define wGrassAnimationModifier	$cc36

; Used by the eye statue puzzle before the ganon/twinrova fight
.define wEyePuzzleCounter $cc37

; FF for overworld, other for mapped areas
.define wDungeonIndex $cc39

; Index on map for mapped areas (dungeons)
.define wDungeonMapPosition	$cc3a
; Index for w2DungeonLayout, possibly used for floors?
.define wDungeonFloor		$cc3b

.define wDungeonRoomProperties	$cc3c

; 8 bytes of dungeonData copied to here
.define wDungeonMapData		$cc3d

; The high byte of the dungeon flags (wGroup4Flags/wGroup5Flags)
.define wDungeonFlagsAddressH	$cc3d

; Warp destination index to use when a wallmaster grabs you
.define wDungeonWallmasterDestRoom	$cc3e

.define wDungeonFirstLayout	$cc3f ; Index of dungeon layout data for first floor
.define wDungeonNumFloors	$cc40
.define wDungeonMapBaseFloor	$cc41 ; Determines what the map will call the bottom floor (0 for "B3")
.define wMapFloorsUnlockedWithCompass	$cc42 ; Bitset of floors that are unlocked on the map with the compass
.define wDungeonData6	$cc43
.define wDungeonData7	$cc44

.define wLoadingRoomPack	$cc45

.define wActiveMusic2	$cc46


.define wWarpDestVariables $cc47
.define wWarpDestVariables.size $05

; Like wActiveGroup, except among other things, bit 7 can be set. Dunno what
; that means.
.define wWarpDestGroup	$cc47
.define wWarpDestIndex	$cc48 ; This first holds the warp destination index, then the room index.
.define wWarpTransition	$cc49
.define wWarpDestPos	$cc4a
.define wWarpTransition2	$cc4b

; wWarpTransition is the half-byte given in WarpDest or StandardWarp macros.
; wWarpTransition2 is set by code.
;
; Values for wWarpTransition2:
; 00: none
; 01: instant
; 03: fadeout

; 2 bytes.
.define wSeedTreeRefilledBitset	$cc4d

; Write $0b to here to force link to continue moving
.define wForceMovementTrigger $cc4f
; Write the number of pixels link should move into here
.define wForceMovementLength  $cc51


.define wSwordDisabledCounter	$cc59

.define wCc5a	$cc5a

; cc5c-cce9 treated as a block

; Bit 7: lock link's movement direction
; Bit 0: set when jumping down a cliff
.define wLinkControl		$cc5c

; 2 bytes
.define wPegasusSeedCounter	$cc6c
; Not sure what uses this or what its Deeper Meaning is
.define wWarpsDisabled		$cc6e

; Related to whether a valid secret was entered?
.define wSecretInputResult	$cc89

; TODO: look into what different values for this.
; $01 and $80 both freeze him in place.
; $02 disables interactions.
.define wLinkCantMove		$cc8a

.define wUnknownPosition	$cc8e

.define wNumTorchesLit $cc8f

; The tile Link is standing on
.define wActiveTilePos   $cc99
.define wActiveTileIndex $cc9a

; Different values for grass, stairs, water, etc
.define wActiveTileType		$cc9c
.define wLastActiveTileType	$cc9d

; Position of chest link is standing on ($00 doesn't count)
.define wLinkOnChest	$cc9f

; Keeps track of which switches are set (buttons on the floor)
.define wActiveTriggers $cca0

; $cca9: relates to ganon/twinrova fight somehow

; Color of the rotating cube (0-2)
; Bit 7 gets set when the torches are lit
.define wRotatingCubeColor   $ccad
.define wRotatingCubePos     $ccae

; Not sure what purpose this is for
.define wDisableWarps	$ccb2

; List of objects which react to A button presses. Each entry is a pointer to
; the object's PRESSEDABUTTON variable.
.define wAButtonSensitiveObjectList	$ccb3
.define wAButtonSensitiveObjectListEnd	wAButtonSensitiveObjectList+$20

.define wCcd3		$ccd3

.define wIsLinkBeingShocked	$ccdb
.define wLinkShockCounter	$ccdc

; Indices for w2AnimationQueue
.define wAnimationQueueHead	$cce4
.define wAnimationQueueTail	$cce5

; cce7: object type, cce8: object index

; This might be a marker for the end of data in the $cc00 block?
.define wCCE9			$cce9

; Next $30 bytes are treated as a unit in a certain place
.define wScreenVariables $cd00
.define wScreenVariables.size $30

; Equals 1 under most normal circumstances
; Equals 8 while doing a normal screen transition
; When set to 0, scrolling stops in big areas.
; Bit 0 disables animations when unset, among other things apparently.
; When bit 1 is set link can't move.
; Bit 2 is set when link is doing a walk-out-of-screen transition.
; Bit 7 is set while the screen is scrolling or text is on the screen
.define wScrollMode $cd00

; See constants/directions.s for what the directions are
.define wScreenTransitionDirection $cd02

; These are probably used when the screen shakes back and forth
.define wScreenOffsetY	$cd08
.define wScreenOffsetX	$cd09

; $cd0d, cd0f: Y positions of something?

.define wCameraFocusedObjectType	$cd16
.define wCameraFocusedObject		$cd17

.define wScreenShakeCounterY $cd18
.define wScreenShakeCounterX $cd19

.define wAreaUniqueGfx	$cd20
.define wAreaGfx	$cd21
.define wAreaPalette	$cd22
.define wAreaTileset	$cd23
.define wAreaLayoutGroup $cd24
.define wAreaAnimation	$cd25

.define wLoadedAreaUniqueGfx	$cd28
.define wLoadedAreaPalette	$cd29
.define wLoadedAreaTileset	$cd2a
.define wLoadedAreaAnimation	$cd2b

; Bits 0-3 determine whether to use animation data 1-4
; When bit 7 is set, all animations are forced to be updated regardless of
; counters.
; Bit 6 also does something
.define wAnimationState		$cd30

.define wAnimationCounter1	$cd31
.define wAnimationPointer1	$cd32
.define wAnimationCounter2	$cd34
.define wAnimationPointer2	$cd35
.define wAnimationCounter3	$cd37
.define wAnimationPointer3	$cd38
.define wAnimationCounter4	$cd3a
.define wAnimationPointer4	$cd3b

; Used temporarily for vram transfers, dma.
.define wTmpVramBuffer		$cd40

.define wStaticObjects		$cd80
.define wStaticObjects.size	$40

.define wNumEnemies $cdd1

; State of the blocks that are toggled by the orbs
.define wToggleBlocksState	$cdd2

; Each bit keeps track of whether a certain switch has been hit
; Persists between rooms?
.define wSwitchState $cdd3

; Write anything to here to make link die
.define wLinkDeathTrigger	$cdd5

; Link's position (plus 1 so 0 is a special value) when he gets sent back from
; an attempt to travel through time. When set, breakable tiles like bushes will
; be deleted so that Link doesn't get caught in an infinite time loop.
.define wLinkTimeWarpTile	$cddc


.define wRoomCollisions	$ce00

.define wItemGraphicData $cec0
.define wTmpNumEnemies $cec1
.define wTmpEnemyPos $cec2

.define wRoomLayout	$cf00
.define wRoomLayoutEnd	$cfb0

; Used in the cutscene after jabu as a sort of cutscene state thing?
; Also used by scripts, possibly just as a scratch variable?
.define wCFC0		$cfc0
; Another cutscene thing?
.define wCFC1		$cfc1

; 8 byte buffer of some kind
; Used in events triggered by stuff falling down holes
.define wCFD8		$cfd8

; Bank 1: objects

.define w1LinkEnabled	$d000
.define w1LinkID	$d001
.define w1LinkState	$d004
.define w1LinkFacingDir	$d008
.define w1LinkYH	$d00b
.define w1LinkXH	$d00d
.define w1LinkZH	$d00f
.define w1LinkVisible	$d01a
.define w1Link1e	$d01e
.define w1Link24	$d024
.define w1Link2a	$d02a
.define w1LinkInvincibilityCounter $d02b
.define w1Link31	$d031
.define w1Link32	$d032

; Maple also uses this slot
.define w1CompanionEnabled	$d100
.define w1CompanionState	$d104
.define w1CompanionFacingDir	$d108
.define w1CompanionYH		$d10b
.define w1CompanionXH		$d10d
.define w1CompanionZH		$d10f
.define w1CompanionVisible	$d11a
.define w1CompanionInvincibilityCounter	$d12b
.define w1Companion31		$d131


.define LINK_OBJECT_INDEX	$d0
.define COMPANION_OBJECT_INDEX	$d1
.define FIRST_INTERACTION_INDEX	$d2
.define FIRST_ITEM_INDEX	$d6
.define FIRST_ENEMY_INDEX	$d0
.define FIRST_PART_INDEX	$d0


; Bank 2: used for palettes & other things

.RAMSECTION "RAM 2" BANK 2 SLOT 3

w2Filler1:			dsb $0800

w2Unknown2:			dsb $80	; $d800

w2Filler7:			dsb $80

; Tree refill data also used for child and an event in room $2f7
w2SeedTreeRefillData:		dsb $080 ; $d900

w2Unknown1:			dsb $010 ; $d980

w2Filler6:			dsb $70

w2ColorComponentBuffer1:	dsb $090 ; $da00
w2Unknown5: 			dsb $070 ; $da90
w2ColorComponentBuffer2:	dsb $090 ; $db00

w2AnimationQueue:		dsb $20	; $db90

w2Filler4:			dsb $50

; Each $40 bytes is one floor
w2DungeonLayout:	dsb $100	; $dc00

w2Filler2: dsb $100

w2GbaModePaletteData:	dsb $80		; $de00

w2AreaBgPalettes:	dsb $40		; $de80
w2AreaSprPalettes:	dsb $40		; $dec0

w2BgPalettesBuffer:	dsb $40		; $df00
w2SprPalettesBuffer:	dsb $40		; $df40

w2FadingBgPalettes:	dsb $40		; $df80
w2FadingSprPalettes:	dsb $40		; $dfc0

.ENDS

; Bank 3: tileset data
;
.RAMSECTION "RAM 3" BANK 3 SLOT 3

; 8 bytes per tile: 4 for tile indices, 4 for tile attributes
w3TileMappingData:	dsb $800	; $d000

; Room tiles in a format which can be written straight to vram. Each row is $20
; bytes.
w3VramTiles:		dsb $100	; $d800

w3Filler1:		dsb $200

; Each byte is the collision mode for that tile.
; The lower 4 bits seem to indicate which quarters are solid.
w3TileCollisions:	dsb $100	; $db00

; Indices for tileMappingTable. 2 bytes each, $100 tiles total.
w3TileMappingIndices:	dsb $200	; $dc00

; Analagous to w3VramTiles. Contains the attributes to write to vram.
; Same memory used as w3TileMappingIndices.
; w3VramAttributes:	dsb $200	; $dc00

w3Filler2:		dsb $100

w3RoomLayoutBuffer:	dsb $100	; $df00

.ENDS

.RAMSECTION "Ram 4" BANK 4 SLOT 3

w4TileMap:		dsb $240	; $d000-$d240
w4StatusBarTileMap:	dsb $40		; $d240
w4PaletteData:		dsb $40		; $d280
w4Filler3:		dsb $40
w4SavedOam:		dsb $a0		; $d300
w4Filler4:		dsb $40
w4Unknown1:		dsb $20		; $d3e0

w4AttributeMap:		dsb $240	; $d400-$d640
w4StatusBarAttributeMap:	dsb $40		; $d640
w4ItemGfx:		dsb $80		; $d680
w4Filler5:		dsb $80

w4FileDisplayVariables:		INSTANCEOF FileDisplayStruct 3	; $d780

w4Filler7:		dsb 8

w4NameBuffer:		dsb 6		; $d7a0
w4Filler6:		dsb $1a
w4SecretBuffer:		dsb $20		; $d7c0
w4Filler8:		dsb $20

w4SavedVramTiles:	dsb $180	; $d800

w4Filler1:		dsb $280
w4GfxBuf1:		dsb $200	; $dc00
w4GfxBuf2:		dsb $200	; $de00

.ENDS

.RAMSECTION "Ram 5" BANK 5 SLOT 3

w5NameEntryCharacterGfx:	dsb $100	; $d000

.ENDS

; Bank 7: used for text

.define TEXT_BANK $07

; Mapping for textbox. Goes with w7TextboxAttributes.
; Each row is $20 bytes, and there are 5 rows. So this should take $a0 bytes.
.define w7TextboxMap	$d000

.define w7TextDisplayState $d0c0

; When bit 0 is set, text skips to the end of a line (A or B was pressed)
; When bit 2 is set, an "\opt()" command has been encountered
; When bit 3 is set, an option prompt has already been shown?
; When bit 4 is set, an extra text index will be shown when this text is done.
; See _getExtraTextIndex.
; When bit 5 is set, it shows the heart icon like when you get a piece of heart.
.define w7d0c1		$d0c1

; This is $00 when the text is done, $01 when a newline is encountered, and $ff
; for anything else?
.define w7TextStatus		$d0c2

; w7SoundEffect is a one-off sound effect, while w7TextSound is the sound that
; each character makes as it's displayed.
.define w7SoundEffect	$d0c3
.define w7TextSound	$d0c4

; How many frames each character is displayed for before the next appears
.define w7CharacterDisplayLength	$d0c5
; The timer until the next character will be displayed
.define w7CharacterDisplayTimer		$d0c6

; The attribute byte for subsequent characters. This is the byte that is
; written into vram bank 1, which determines which palette to use and stuff
; like that.
.define w7TextAttribute	$d0c7

; Whether or not the little red arrow in the bottom-right is being displayed.
; This can be eiher $02 (not displayed) or $03 (displayed).
; This changes every 16 frames.
.define w7TextArrowState $d0c8

; These 3 bytes specify where the tilemap for the textbox is located. It points
; to the start of the row where it should be displayed.
.define w7TextboxPosBank $d0c9
.define w7TextboxPosL	$d0ca
.define w7TextboxPosH	$d0cb
; d0cc: low byte of where to save the tiles under the textbox?
.define w7d0cc		$d0cc

; The next column of text to be shown
.define w7NextTextColumnToDisplay	$d0d0

; This variable is used by the retrieveTextCharacter function.
; 0: read a normal character
; 1: read a kanji
; 2: read a trade item symbol
.define w7TextGfxSource	$d0d2

; Textbox position?
.define w7d0d3		$d0d3

.define w7ActiveBank	$d0d4
; d0d5/6: address of text being read?
.define w7TextAddressL	$d0d5
.define w7TextAddressH	$d0d6

; d0d7: counter for how long to slow down the text? (Used for getting essences)
.define w7TextSlowdownTimer $d0d7

; Similar to w7TextboxPos, but this points to the vram where it ends up.
.define w7TextboxVramPosL $d0d8
.define w7TextboxVramPosH $d0d9

.define w7InvTextScrollTimer	$d0de
; Number of spaces to be inserted before looping back to the start of the text.
.define w7InvTextSpaceCounter	$d0df

; This is 8 bytes. Each byte correspond to a position for an available option
; in the text prompt.
; The bytes can be written straight to w7TextboxMap as the indices for the
; tiles that would normally be in those positions. They can also be converted
; into an INDEX for w7TextboxMap with the _getAddressInTextboxMap function.
.define w7TextboxOptionPositions $d0e0

; Note that this is distinct from wSelectedTextOption, but they behave very
; similarly. This is just used internally in text routines.
.define w7SelectedTextOption	$d0e8
; The corresponding value from w7TextboxOptionPositions.
.define w7SelectedTextPosition		$d0e9

.define w7d0ea		$d0ea

; Number of frames until the textbox closes itself.
.define w7TextboxTimer		$d0eb
.define w7TextIndexL_backup			$d0ec

; How many spaces to put after the name of the item.
; This is calculated so that the item name appears in the middle.
.define w7InvTextSpacesAfterName	$d0ed

; Frame counter until the next time a character should play its sound effect.
; While nonzero, the text scrolling sound doesn't play (although explicit sound
; effects do play).
.define w7TextSoundCooldownCounter	$d0ee

.define w7d0ef		$d0ef

.define w7TextTableAddr $d0f0
.define w7TextTableBank $d0f2

; How big is this?
.define w7TextboxAttributes	$d100

; $20 bytes total, 4 bytes per entry. When looking up a word in a dictionary,
; this remembers the position it left off at.
; b0: bank of text where it left off
; b1/2: address of text where it left off
; b3: high byte of text index
.define w7TextStack	$d1c0

; Holds a line of text graphics. $200 bytes.
.define w7TextGfxBuffer $d200

; The text for the line
.define w7LineTextBuffer	$d400
; The attributes for the line
.define w7LineAttributesBuffer $d410
; The number of frames each character is displayed before the next appears.
.define w7LineDelaysBuffer	$d420
; The sound each character will play as it's displayed.
.define w7LineSoundsBuffer	$d430
; Sound effects created by the "sfx" command (ie. goron noise)
.define w7LineSoundEffectsBuffer	$d440
; Bit 0 of a byte in this buffer is set if the text can be advanced with the
; A/B buttons.
.define w7LineAdvanceableBuffer		$d450

.define w7SecretBuffer1		$d460
.define w7SecretBuffer2		$d46c
; Manually define the bank number for now
.define :w7SecretBuffer1	$07

; $d5e0: Used at some point for unknown purpose

; Custom stuff
.ENUM $da00
	w7TmpBuf:		dsb $20
	w7TextBufPosition:	db
	w7TextCharOffset	db
	w7TextCharIndex		db

	w7InvTextUnfinishedCharacter db
	w7InvTextHaltOnNewline	db
.ENDE



; Interaction variables (objects in dx40-dx7f)
.define INTERAC_START		$40
.define INTERAC_ENABLED		$40
.define INTERAC_ID		$41
.define INTERAC_SUBID		$42
.define INTERAC_43		$43
.define INTERAC_STATE		$44
.define INTERAC_STATE_2		$45

; Counter1 is used by the checkabutton command among others. checkabutton
; doesn't activate until it reaches zero.
.define INTERAC_COUNTER1	$46
.define INTERAC_COUNTER2	$47

.define INTERAC_DIRECTION	$48
.define INTERAC_MOVINGDIRECTION	$49
.define INTERAC_Y		$4a
.define INTERAC_YH		$4b
.define INTERAC_X		$4c
.define INTERAC_XH		$4d
.define INTERAC_Z		$4e
.define INTERAC_ZH		$4f
.define INTERAC_SPEED		$50
.define INTERAC_SPEED_Z		$54
.define INTERAC_RELATEDOBJ	$56
.define INTERAC_RELATEDOBJ2	$58
.define INTERAC_SCRIPTPTR	$58 ; Shared with RELATEDOBJ2
.define INTERAC_VISIBLE		$5a
.define INTERAC_5B		$5b
.define INTERAC_OAM_FLAGS	$5c
.define INTERAC_OAM_TILEINDEX_BASE	$5d
.define INTERAC_5E		$5e
.define INTERAC_ANIMCOUNTER	$60
.define INTERAC_61		$61
.define INTERAC_ANIMPOINTER	$62
.define INTERAC_COLLIDERADIUSY	$66
.define INTERAC_COLLIDERADIUSX	$67
.define INTERAC_68		$68
.define INTERAC_69		$69
.define INTERAC_6a		$6a
.define INTERAC_6b		$6b
.define INTERAC_6c		$6c
.define INTERAC_6d		$6d
.define INTERAC_6e		$6e
.define INTERAC_6f		$6f

; $70 used by showText; if nonzero, INTERAC_TEXTID replaces whatever upper byte you use in a showText opcode.
.define INTERAC_USETEXTID	$70
; $70 might have a second purpose?
.define INTERAC_70		$70

.define INTERAC_PRESSEDABUTTON	$71
; $71 might have a second purpose?
.define INTERAC_71		$71

; 2 bytes
.define INTERAC_TEXTID		$72

.define INTERAC_72		$72
.define INTERAC_73		$73
.define INTERAC_74		$74
.define INTERAC_SCRIPT_RET	$75
.define INTERAC_75		$75
.define INTERAC_76		$76
.define INTERAC_77		$77
.define INTERAC_78		$78
.define INTERAC_79		$79
.define INTERAC_7a		$7a
.define INTERAC_7b		$7b
.define INTERAC_7c		$7c
.define INTERAC_7d		$7d
.define INTERAC_7e		$7e
.define INTERAC_7f		$7f

; Enemy variables (objects in dx80-dxbf)
.define ENEMY_START		$80
.define ENEMY_ENABLED		$80
.define ENEMY_ID		$81
.define ENEMY_SUBID		$82
.define ENEMY_83		$83
.define ENEMY_STATE		$84
.define ENEMY_COUNTER1		$86
.define ENEMY_DIRECTION		$88
.define ENEMY_Y			$8a
.define ENEMY_YH		$8b
.define ENEMY_X			$8c
.define ENEMY_XH		$8d
.define ENEMY_Z			$8e
.define ENEMY_ZH		$8f
.define ENEMY_SPEED_Z		$94
.define ENEMY_RELATEDOBJ1	$96
.define ENEMY_RELATEDOBJ2	$98
.define ENEMY_VISIBLE		$9a ; More than just visibility
.define ENEMY_9b		$9b
.define ENEMY_9c		$9b
.define ENEMY_ANIMCOUNTER	$a0
; A4 - used by pumpkin head, at least, when the ghost dies
.define ENEMY_a4		$a4
; A5 - collision properties - determines whether you'll get damaged?
.define ENEMY_COLLIDEPROPERTIES	$a5
.define ENEMY_COLLIDERADIUSY	$a6
.define ENEMY_COLLIDERADIUSX	$a7
.define ENEMY_DAMAGE		$a8
.define ENEMY_HEALTH		$a9
.define ENEMY_aa		$aa
.define ENEMY_ab		$ab
.define ENEMY_ac		$ac
.define ENEMY_ad		$ad
.define ENEMY_FROZEN_TIMER	$ae


; Part variables (objects in dxc0-dxff)
.define PART_START		$c0
.define PART_ENABLED		$c0
.define PART_ID			$c1
.define PART_SUBID		$c2
.define PART_c3			$c3
.define PART_STATE		$c4
.define PART_DIRECTION		$c8
.define PART_MOVINGDIRECTION	$c9
.define PART_Y			$ca
.define PART_YH			$cb
.define PART_X			$cc
.define PART_XH			$cd
.define PART_Z			$ce
.define PART_ZH			$cf
.define PART_RELATEDOBJ1	$d6
.define PART_RELATEDOBJ2	$d8
.define PART_ANIMCOUNTER	$e0
.define PART_ANIMPOINTER	$e2
.define PART_e4			$e4
.define PART_e5			$e5
.define PART_e6			$e6
.define PART_DAMAGE		$e8
.define PART_ea			$ea

; General definitions for objects
.define OBJ_ENABLED		$00
.define OBJ_ID			$01
.define OBJ_SUBID		$02
.define OBJ_STATE		$04
.define OBJ_STATE_2		$05
.define OBJ_COUNTER1		$06
.define OBJ_COUNTER2		$07
.define OBJ_DIRECTION		$08
.define OBJ_MOVINGDIRECTION	$09
.define OBJ_Y			$0a
.define OBJ_YH			$0b
.define OBJ_X			$0c
.define OBJ_XH			$0d
.define OBJ_Z			$0e
.define OBJ_ZH			$0f
.define OBJ_SPEED		$10
.define OBJ_SPEED_TMP		$11
.define OBJ_12			$12
.define OBJ_SPEED_Z		$14
.define OBJ_RELATEDOBJ1		$16
.define OBJ_RELATEDOBJ2		$18
; Bit 7 of OBJ_VISIBLE tells if it's visible, bits 0-1 determine its priority,
; bit 6 is set if the object has a shadow
.define OBJ_VISIBLE		$1a

.define OBJ_OAM_FLAGS		$1c
.define OBJ_OAM_TILEINDEX_BASE	$1d
.define OBJ_1e			$1e

.define OBJ_ANIMCOUNTER		$20
.define OBJ_ANIMPOINTER		$22
.define OBJ_COLLIDERADIUSY	$26
.define OBJ_COLLIDERADIUSX	$27
.define OBJ_DAMAGE		$28
.define OBJ_HEALTH		$29
.define OBJ_2a			$2a
.define OBJ_35			$35
.define OBJ_36			$36

; Link-specific variables

; Used as a counter for harp warps, and is 1 when link is doing
; a walk-off-screen transition
.define LINK_WARP_VAR		$05
.define LINK_WARP_VAR_2		$06
.define LINK_2b			$2b
.define LINK_2d			$2d
.define LINK_ANIM_MODE		$30
