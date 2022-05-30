[![CI](https://github.com/AnnikaCodes/mac68k/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/AnnikaCodes/mac68k/actions/workflows/CI.yml)

You shouldn't expect this project to work; nor should you run it on real hardware.

# Useful addresses and notes
- VIA
    - `0xF00000` to `0xF80000` on the 128k, 512k, Plus and SE
    - doesn't exist on Macintosh Portable? unclear
    - `0x50000000` to `0x50002000` on the SE/30, II, IIx, IIcx, IIfx and IIci
        - On systems with a second VIA, it is located at `0x50002000` to `0x50004000`
- IWM ("Integrated Woz Machine" floppy controller)
    - `0xE00000` to `0xD00000` on the 128k, 512k, Plus and SE
    - Other models have a SWIM floppy controller from `0x50016000` to `0x50018000`, except the Macintosh Portable and IIfx which have SWIMs at `0xF60000` and `0x50012000` respectively
- See page 42 of the *[Guide to the Macintosh Family Hardware, 2nd Edition](https://archive.org/details/apple-guide-macintosh-family-hardware)* for more info.

It looks like supporting the Portable and IIfx will likely be more complex. Support can initially be focused on the 128k/512k/Plus/SE with support for the Macintosh II-line coming later.