MAIN:
	0x08048529 <+0>:	push   %ebp
	0x0804852a <+1>:	mov    %esp,%ebp

	These two instructions set up the stack frame for the function. 
	The current value of the base pointer (%ebp) is pushed onto the stack, and then the value of the stack pointer (%esp) is copied into the base pointer.

	0x0804852c <+3>:	push   %edi
	0x0804852d <+4>:	push   %esi
	0x0804852e <+5>:	push   %ebx

	These instructions push the values of registers %edi, %esi, and %ebx onto the stack.
	This is done to preserve the values of these registers so that they can be restored later.

	0x0804852f <+6>:	and    $0xfffffff0,%esp

	This instruction aligns the stack pointer (%esp) to a multiple of 16 by performing a bitwise AND with the hexadecimal value 0xfffffff0. 
	Aligning the stack can improve performance on some architectures.

	0x08048532 <+9>:	sub    $0xa0,%esp

	This instruction subtracts 160 bytes from the stack pointer,
	 effectively reserving space for local variables or temporary storage.

	0x08048538 <+15>:	cmpl   $0x3,0x8(%ebp)
	0x0804853c <+19>:	je     0x8048548 <main+31>
	0x0804853e <+21>:	mov    $0x1,%eax
	0x08048543 <+26>:	jmp    0x8048630 <main+263>

	These instructions are part of a conditional branch. It compares the value at memory location %ebp + 8 with the value 0x3. If they are equal (je), it jumps to the address 0x8048548.
	 Otherwise, it sets %eax to 0x1 and jumps to the address 0x8048630.

		if (argc != 3)
	{
		eax = 1;
	}

	0x08048548 <+31>:	lea    0x50(%esp),%ebx

	This instruction calculates the effective address of %esp + 0x50 and stores it in the register %ebx. 
	It is often used to perform arithmetic calculations with memory addresses.

	0x0804854c <+35>:	mov    $0x0,%eax
	0x08048551 <+40>:	mov    $0x13,%edx
	0x08048556 <+45>:	mov    %ebx,%edi
	0x08048558 <+47>:	mov    %edx,%ecx
	0x0804855a <+49>:	rep stos %eax,%es:(%edi)

	These instructions use the rep stos instruction to set a block of memory starting from the address %edi with %ecx number of bytes. The value %eax is stored in each byte.
	In this case, %eax is 0x0, %edi is the effective address %esp + 0x50, and %ecx is 0x13 (19 in decimal).

	memset(&var_60, 0, 0x4c);


	0x0804855c <+51>:	mov    0xc(%ebp),%eax
	0x0804855f <+54>:	add    $0x4,%eax
	0x08048562 <+57>:	mov    (%eax),%eax

	====== need explain

	0x08048564 <+59>:	movl   $0x28,0x8(%esp)
	0x0804856c <+67>:	mov    %eax,0x4(%esp)
	0x08048570 <+71>:	lea    0x50(%esp),%eax
	0x08048574 <+75>:	mov    %eax,(%esp)
	0x08048577 <+78>:	call   0x80483c0 <strncpy@plt>

	These instructions are calling the strncpy function. The source string is obtained from (%eax), and it is copied to the destination string located at 0x50(%esp). 
	The third argument is 0x28 (40 in decimal), which specifies the maximum number of characters to copy.

	strncpy(var_b0, var_ac, 0x28); //40


	0x0804857c <+83>:	mov    0xc(%ebp),%eax
	0x0804857f <+86>:	add    $0x8,%eax
	0x08048582 <+89>:	mov    (%eax),%eax

	These instructions retrieve the value at the memory location %ebp + 0xc + 0x8 and store it in the %eax register.

	0x08048584 <+91>:	movl   $0x20,0x8(%esp)
	0x0804858c <+99>:	mov    %eax,0x4(%esp)
	0x08048590 <+103>:	lea    0x50(%esp),%eax
	0x08048594 <+107>:	add    $0x28,%eax
	0x08048597 <+110>:	mov    %eax,(%esp)
	0x0804859a <+113>:	call   0x80483c0 <strncpy@plt>

	These instructions are another call to the strncpy function. 
	The source string is obtained from (%eax), and it is copied to the destination string located at 0x50(%esp). 
	The third argument is 0x20 (32 in decimal), which specifies the maximum number of characters to copy.

	0x0804859f <+118>:	movl   $0x8048738,(%esp)
	0x080485a6 <+125>:	call   0x8048380 <getenv@plt>
	0x080485ab <+130>:	mov    %eax,0x9c(%esp)

	These instructions call the getenv function to retrieve the value of the environment variable specified by the string at memory location 0x8048738.
	The return value is stored in 0x9c(%esp).

	0x080485b2 <+137>:	cmpl   $0x0,0x9c(%esp)
	0x080485ba <+145>:	je     0x8048618 <main+239>

	This instruction compares the value at memory location 0x9c(%esp) with 0x0. If they are equal (je), it jumps to the address 0x8048618.

	0x080485bc <+147>:	movl   $0x2,0x8(%esp)
	0x080485c4 <+155>:	movl   $0x804873d,0x4(%esp)
	
	===== need explain
	
	0x080485cc <+163>:	mov    0x9c(%esp),%eax
	0x080485d3 <+170>:	mov    %eax,(%esp)
	0x080485d6 <+173>:	call   0x8048360 <memcmp@plt>
	0x080485db <+178>:	test   %eax,%eax
	0x080485dd <+180>:	jne    0x80485eb <main+194>

	These instructions call the memcmp function to compare the contents of the memory location specified by %esp with the string at memory location 0x804873d. 
	The return value is stored in %eax. 
	The test instruction checks if %eax is zero, and if not (jne), it jumps to the address 0x80485eb.
	
	0x080485df <+182>:	movl   $0x1,0x8049988
	0x080485e9 <+192>:	jmp    0x8048618 <main+239>

	These instructions set the value at memory location 0x8049988 to 0x1 and jump to the address 0x8048618.

	0x080485eb <+194>:	movl   $0x2,0x8(%esp)
	0x080485f3 <+202>:	movl   $0x8048740,0x4(%esp)
	0x080485fb <+210>:	mov    0x9c(%esp),%eax
	0x08048602 <+217>:	mov    %eax,(%esp)
	0x08048605 <+220>:	call   0x8048360 <memcmp@plt>
	0x0804860a <+225>:	test   %eax,%eax
	0x0804860c <+227>:	jne    0x8048618 <main+239>

	These instructions are similar to the previous block, but the memcmp function is comparing with a different string at memory location 0x8048740.
	The jump is taken if the result of the comparison is non-zero.

	0x0804860e <+229>:	movl   $0x2,0x8049988
	0x08048618 <+239>:	mov    %esp,%edx
	0x0804861a <+241>:	lea    0x50(%esp),%ebx
	0x0804861e <+245>:	mov    $0x13,%eax
	0x08048623 <+250>:	mov    %edx,%edi
	0x08048625 <+252>:	mov    %ebx,%esi
	0x08048627 <+254>:	mov    %eax,%ecx
	0x08048629 <+256>:	rep movsl %ds:(%esi),%es:(%edi)

	These instructions copy a block of memory from %esi to %edi.
	The length of the block is specified by %ecx and the size of each element is determined by the instruction rep movsl.
	The block of memory being copied starts at %esi and is copied to %edi. 
	The length of the block is 0x13 (19 in decimal).

	0x0804862b <+258>:	call   0x8048484 <greetuser>
	
	===need explain
	
	0x08048630 <+263>:	lea    -0xc(%ebp),%esp
	0x08048633 <+266>:	pop    %ebx
	0x08048634 <+267>:	pop    %esi
	0x08048635 <+268>:	pop    %edi
	0x08048636 <+269>:	pop    %ebp
	0x08048637 <+270>:	ret

	These instructions are part of the function epilogue. 
	They restore the stack pointer %esp to its previous value by loading %ebp into %esp.
	 Then, the original values of %ebx, %esi, %edi, and %ebp are restored from the stack, and the function returns with ret. 
	 This sequence effectively cleans up the stack and restores the state before the function call.




frame_dummy:
	0x08048460 <+0>:	push   %ebp
	0x08048461 <+1>:	mov    %esp,%ebp
	0x08048463 <+3>:	sub    $0x18,%esp
	0x08048466 <+6>:	mov    0x8049880,%eax
	0x0804846b <+11>:	test   %eax,%eax
	0x0804846d <+13>:	je     0x8048481 <frame_dummy+33>
	0x0804846f <+15>:	mov    $0x0,%eax
	0x08048474 <+20>:	test   %eax,%eax
	0x08048476 <+22>:	je     0x8048481 <frame_dummy+33>
	0x08048478 <+24>:	movl   $0x8049880,(%esp)
	0x0804847f <+31>:	call   *%eax
	0x08048481 <+33>:	leave  
	0x08048482 <+34>:	ret    
	0x08048483 <+35>:	nop


greetuser:
	0x08048484 <+0>:	push   %ebp
	0x08048485 <+1>:	mov    %esp,%ebp
	0x08048487 <+3>:	sub    $0x58,%esp

	These instructions set up the function prologue. The previous value of the base pointer (%ebp) is pushed onto the stack. Then, the current stack pointer (%esp) is moved into the base pointer to create a new base pointer.
	Finally, space for local variables is reserved on the stack by subtracting 0x58 (88 in decimal) from the stack pointer.

	0x0804848a <+6>:	mov    0x8049988,%eax
	0x0804848f <+11>:	cmp    $0x1,%eax
	0x08048492 <+14>:	je     0x80484ba <greetuser+54>
	0x08048494 <+16>:	cmp    $0x2,%eax
	0x08048497 <+19>:	je     0x80484e9 <greetuser+101>
	0x08048499 <+21>:	test   %eax,%eax
	0x0804849b <+23>:	jne    0x804850a <greetuser+134>

	These instructions check the value stored at memory address 0x8049988 (likely a flag or control variable). 
	The value is loaded into %eax, and then it is compared against different values using cmp instructions. 
	If the comparisons are true, conditional jumps are taken to specific memory addresses. 
	The jump targets (0x80484ba, 0x80484e9, 0x804850a) represent different code paths based on the value of %eax.

	0x0804849d <+25>:	mov    $0x8048710,%edx
	0x080484a2 <+30>:	lea    -0x48(%ebp),%eax		--> -72 bytes
	0x080484a5 <+33>:	mov    (%edx),%ecx
	0x080484a7 <+35>:	mov    %ecx,(%eax)
	0x080484a9 <+37>:	movzwl 0x4(%edx),%ecx
	0x080484ad <+41>:	mov    %cx,0x4(%eax)
	0x080484b1 <+45>:	movzbl 0x6(%edx),%edx
	0x080484b5 <+49>:	mov    %dl,0x6(%eax)
	0x080484b8 <+52>:	jmp    0x804850a <greetuser+134>

	These instructions copy values from memory addresses (0x8048710, %edx) to the stack frame (-0x48(%ebp), %eax).
	The source values are loaded into registers using mov instructions, and then they are stored in the destination memory locations.
	The movzwl and movzbl instructions perform zero-extension operations to handle different-sized data.
	Finally, an unconditional jump is taken to memory address 0x804850a.

	0x080484ba <+54>:	mov    $0x8048717,%edx
	0x080484bf <+59>:	lea    -0x48(%ebp),%eax
	0x080484c2 <+62>:	mov    (%edx),%ecx
	0x080484c4 <+64>:	mov    %ecx,(%eax)
	0x080484c6 <+66>:	mov    0x4(%edx),%ecx
	0x080484c9 <+69>:	mov    %ecx,0x4(%eax)
	0x080484cc <+72>:	mov    0x8(%edx),%ecx
	0x080484cf <+75>:	mov    %ecx,0x8(%eax)
	0x080484d2 <+78>:	mov    0xc(%edx),%ecx
	0x080484d5 <+81>:	mov    %ecx,0xc(%eax)
	0x080484d8 <+84>:	movzwl 0x10(%edx),%ecx
	0x080484dc <+88>:	mov    %cx,0x10(%eax)
	0x080484e0 <+92>:	movzbl 0x12(%edx),%edx
	0x080484e4 <+96>:	mov    %dl,0x12(%eax)
	0x080484e7 <+99>:	jmp    0x804850a <greetuser+134>
	0x080484e9 <+101>:	mov    $0x804872a,%edx
	0x080484ee <+106>:	lea    -0x48(%ebp),%eax
	0x080484f1 <+109>:	mov    (%edx),%ecx
	0x080484f3 <+111>:	mov    %ecx,(%eax)
	0x080484f5 <+113>:	mov    0x4(%edx),%ecx
	0x080484f8 <+116>:	mov    %ecx,0x4(%eax)
	0x080484fb <+119>:	mov    0x8(%edx),%ecx
	0x080484fe <+122>:	mov    %ecx,0x8(%eax)
	0x08048501 <+125>:	movzwl 0xc(%edx),%edx
	0x08048505 <+129>:	mov    %dx,0xc(%eax)
	0x08048509 <+133>:	nop
	0x0804850a <+134>:	lea    0x8(%ebp),%eax
	0x0804850d <+137>:	mov    %eax,0x4(%esp)
	0x08048511 <+141>:	lea    -0x48(%ebp),%eax
	0x08048514 <+144>:	mov    %eax,(%esp)
	0x08048517 <+147>:	call   0x8048370 <strcat@plt>
	0x0804851c <+152>:	lea    -0x48(%ebp),%eax
	0x0804851f <+155>:	mov    %eax,(%esp)
	0x08048522 <+158>:	call   0x8048390 <puts@plt>
	0x08048527 <+163>:	leave  
	0x08048528 <+164>:	ret 
