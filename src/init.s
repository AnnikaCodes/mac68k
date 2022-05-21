# A very small bootloader in m68k Assembly to immediately invoke Rust code
# Based on HappyJon (https://github.com/jrsharp/HappyJon/blob/master/demo.s
# and the EMILE bootloader (https://github.com/vivier/EMILE).

.extern entryPoint

.include "thirdparty/macos.i"

.equ stage1_size, 1024
.equ sector_size, 512
.equ first_level_size, sector_size * 2

begin:

ID:          .short  0x4C4B              /* boot blocks signature */
Entry:       bra     start          /* entry point to bootcode */
Version:     .short  0x4418              /* boot blocks version number */
PageFlags:   .short  0x00                /* used internally */
SysName:     pString "foo bar       "    /* System filename */
ShellName:   pString "foo bar       "    /* Finder filename */
Dbg1Name:    pString "foo bar       "    /* debugger filename */
Dbg2Name:    pString "foo bar       "    /* debugger filename */
ScreenName:  pString "foo bar       "    /* name of startup screen */
HelloName:   pString "foo bar       "    /* name of startup program */
ScrapName:   pString "foo bar       "    /* name of system scrap file */
CntFCBs:     .short  10                  /* number of FCBs to allocate */
CntEvts:     .short  20                  /* number of event queue elements */
Heap128K:    .long   0x00004300          /* system heap size on 128K Mac */
Heap256K:    .long   0x00008000          /* used internally */
SysHeapSize: .long   0x00020000          /* system heap size on all machines */

.include "thirdparty/floppy.i"

start:
	moveal SysZone,%a0
	addal %pc@(SysHeapSize),%a0
	SetApplBase
	movel SysZone,TheZone

	get_second_size %d0

	add.l	#4, %d0
	NewPtr
	move.l	%a0, %d0
	bne	malloc_ok
	move.l	#1, %d0
	SysError
malloc_ok:
	add.l	#3, %d0
	and.l	#0xFFFFFFFC.l, %d0

	load_second
	jmp	(%a0)
PRAM_buffer:
	.long	0
end:

.fill stage1_size - (end - begin), 1, 0xda

call_zig:
#	move.w #0xAAAA,%d0
#	.short 0xA9C9
    bsr entryPoint
PRAM_buffer2:
	.long	0
end2:
