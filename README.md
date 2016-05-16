# 8051-Experiments

## Introduction

I finally managed to gather all my ```8051``` programming projects together under one folder. This is pretty much where I started programming. I was fascinated by ```8051``` when I first read a small introduction to it and I quickly ended up reading through the book and a couple more and started playing around with ```Atmel AT89C51 and S52```. This was so much fun. I built so much hardware around 8051 and did tens of projects with it. Overall, I think it changed my life. The neatness and intuitiveness with which ```Intel``` designed the ```8051 architecture``` is really commendable. It is a wonderful invention and I hope at least some of you who have used and programmed at a very low level agree with me.

All the *.asm files were handwritten and assembled using a simple 8051 assembler called ```ASEM-51```. *.lst and *.hex files are outputs of the assemble and can be used to flash microcontrollers with flashing tools. The assembler is included under the ```Assembler``` folder. This just works on Windows, so if you are using Linux, you need to find another way to assemble them.

Remind you, the files are still a pile of mess and sometimes not documented. You may also find that some files are repetitively copied in many places. This is because small modules are used to build bigger sub-routines.


## Assembling

Using ASEM-51 is really easy. Just open up ```command line``` on Windows and change to the directory of your source assembly file.

Then use:
```
ASEM.exe <source> [<object> [<listing>]] [<options>]
```
Here:
```
<source>         .A51/.ASM
<object>         .HEX      (with /OMF-51 option: .OMF)
<listing>        .LST
```

The assembler produces a *.hex file in Intel format. You can change this to OMF-51 using /OMF-51 option. There is more documentation about all the options in ```ASEM_51.DOC```.


## Flashing

This typically needs an ISP programmer. There are also some programmers that support both ```AVR and 8051``` together. Obviosly the ISA has nothing to do with how you flash. The flash memory access interface for ```Atmel microcontrollers```, at least the ```AVR and 8051``` versions is the same I guess. You can find relatively inexpensive programmers on eBay for $25.

It also depends what kind of a chip you have and if it is already soldered etc. I leave this decision up to you. However if you have any questions or need more information, feel free to drop me an email.
