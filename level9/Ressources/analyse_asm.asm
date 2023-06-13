MAIN

	0x080485f4 <+0>:    push   %ebp
	0x080485f5 <+1>:    mov    %esp,%ebp
	These instructions set up the function's stack frame by pushing the value of the base pointer (%ebp) onto the stack and then moving the value of the stack pointer (%esp) into %ebp.
	-------------------------------------------------

	0x080485f7 <+3>:    push   %ebx
	0x080485f8 <+4>:    and    $0xfffffff0,%esp
	0x080485fb <+7>:    sub    $0x20,%esp
	These instructions push the value of the ebx register onto the stack, align the stack pointer to a
	multiple of 16 bytes by performing a bitwise AND with 0xfffffff0,
	and then subtract 32 bytes from the stack pointer to reserve space for local variables.
	-------------------------------------------------

	0x080485fe <+10>:   cmpl   $0x1,0x8(%ebp)
	0x08048602 <+14>:   jg     0x8048610 <main+28>
	These instructions compare the value at address 0x8(%ebp) (which likely represents a function argument) to 1
	 If the comparison result is greater, it jumps to the address 0x8048610, which is main+28.
	--->	
	-------------------------------------------------

	0x08048604 <+16>:   movl   $0x1,(%esp)
	0x0804860b <+23>:   call   0x80484f0 <_exit@plt>
	if the comparison result is not greater, the program sets the value 1 on the top of the stack and then calls the _exit function,
	which is located at the address 0x80484f0. This effectively exits the program.

	10 to 23 we have this :
	---> if (argc <= 1)
			exit(1);
	-------------------------------------------------

	0x08048610 <+28>:   movl   $0x6c,(%esp)
	0x08048617 <+35>:   call   0x8048530 <_Znwj@plt>
	These instructions set the value 0x6c (108 in decimal) on the top of the stack and then call the function _Znwj,
	which is located at the address 0x8048530.


	-------------------------------------------------

	0x0804861c <+40>:   mov    %eax,%ebx
	0x0804861e <+42>:   movl   $0x5,0x4(%esp)			--> 0x5 = 5
	0x08048626 <+50>:   mov    %ebx,(%esp)
	0x08048629 <+53>:   call   0x80486f6 <_ZN1NC2Ei>	--> Call the constructor of N
	0x0804862e <+58>:   mov    %ebx,0x1c(%esp)			--> We put this in 0x1c for later (+96)
	These instructions move the value of %eax (which should contain the return value from the previous function call) into %ebx.
	Then, the value 0x5 is stored at address 0x4(%esp), %ebx is stored at the top of the stack, and the function _ZN1NC2Ei is called.
	--> N *n1 = new N(5);
	
	-------------------------------------------------

	0x08048632 <+62>:   movl   $0x6c,(%esp)
	0x08048639 <+69>:   call   0x8048530 <_Znwj@plt>
	These instructions move the value of %ebx into address 0x1c(%esp).
	Then, the value 0x6c (108 in decimal) is stored at the top of the stack, and the function _Znwj is called.
	-------------------------------------------------

	0x0804863e <+74>:   mov    %eax,%ebx
	0x08048640 <+76>:   movl   $0x6,0x4(%esp)			--> 0x6 = 6
	0x08048648 <+84>:   mov    %ebx,(%esp)
	0x0804864b <+87>:   call   0x80486f6 <_ZN1NC2Ei>	--> Call the constructor of N
	0x08048650 <+92>:	mov    %ebx,0x18(%esp)			--> We put this int 0x18 for later (+108)
	These instructions move the value of %eax (the return value from the previous function call) into %ebx.
	Then, the value 0x6 is stored at address 0x4(%esp), %ebx is stored at the top of the stack, and the function _ZN1NC2Ei is called.
	--> N *n2 = new N(6);
	-------------------------------------------------

	0x08048654 <+96>:   mov    0x1c(%esp),%eax		|--> N *n1_ptr = n1;
	0x08048658 <+100>:  mov    %eax,0x14(%esp)		|--> Where the n1_ptr is stored in the stack (0x14)

	0x0804865c <+104>:  mov    0x18(%esp),%eax		|--> N *n2_ptr = n2;
	0x08048660 <+108>:  mov    %eax,0x10(%esp)		|--> Where the n2_ptr is stored in the stack (0x10)
	These instructions move the value at address 0x1c(%esp) into %eax and then store %eax at address 0x14(%esp).
	Similarly, the value at address 0x18(%esp) is moved into %eax and then stored at address 0x10(%esp).
	-------------------------------------------------

	for argv[1]
	0x08048664 <+112>:  mov    0xc(%ebp),%eax	--> This instruction retrieves the value at address 0xc(%ebp), which refers to the value of the second argument of the function (assuming a typical function prologue). The value is stored in the %eax register.
	0x08048667 <+115>:  add    $0x4,%eax		--> Here, 4 is added to the value in %eax. This is likely done to access the second element (argv[1]) of the argument array.
	0x0804866a <+118>:  mov    (%eax),%eax
	0x0804866c <+120>:  mov    %eax,0x4(%esp)

	for n1_ptr->
	0x08048670 <+124>:  mov    0x14(%esp),%eax		--> We put n1_ptr into $eax
	0x08048674 <+128>:  mov    %eax,(%esp)
	0x08048677 <+131>:  call   0x804870e <_ZN1N13setAnnotationEPc>		--> We call setAnnotation
	These instructions retrieve the value at address 0xc(%ebp), add 0x4 to it, and then dereference the resulting address to obtain a value. This value is moved to address 0x4(%esp). The value at address 0x14(%esp) is moved to %eax, and then it is stored at the top of the stack. Finally, the function _ZN1N13setAnnotationEPc is called.
			
	--> n1_ptr->setAnnotation(argv[1]);
	-------------------------------------------------

	0x0804867c <+136>:  mov    0x10(%esp),%eax
	0x08048680 <+140>:  mov    (%eax),%eax
	=> 0x08048682 <+142>:  mov    (%eax),%edx
	These instructions retrieve the value at address 0x10(%esp), dereference it to obtain another address, and then move the value at that address to %edx

	--> n2_ptr->
	-------------------------------------------------

	0x08048684 <+144>:  mov    0x14(%esp),%eax		--> The value at address 0x14(%esp) is moved into the %eax register.
														This likely corresponds to the value of n1_ptr.
	0x08048688 <+148>:  mov    %eax,0x4(%esp)		--> *n1_ptr. The value in %eax is stored at the address 0x4(%esp), which prepares it to be used as an argument 
	0x0804868c <+152>:  mov    0x10(%esp),%eax		--> The value at address 0x10(%esp) is moved into the %eax register. This likely corresponds to the value of n2_ptr.
	0x08048690 <+156>:  mov    %eax,(%esp)			--> The value in %eax is stored at the top of the stack, effectively preparing it as the first argument for the function call.
	0x08048693 <+159>:  call   *%edx				--> Finally, the function located at the address stored in the %edx register is called. This means that the function being called is determined by the value of %edx, which is a function pointer.
	These instructions move the value at address 0x14(%esp) to %eax and store it at address 0x4(%esp).
	Similarly, the value at address 0x10(%esp) is moved to %eax and stored at the top of the stack.
	Finally, the function located at the address stored in %edx is called.

	--> return ((n2_ptr)->operator+(*n1_ptr));
	-------------------------------------------------

	0x08048695 <+161>:  mov    -0x4(%ebp),%ebx
	0x08048698 <+164>:  leave  
	0x08048699 <+165>:  ret
	These instructions move the value at address -0x4(%ebp) to %ebx, then clean up the stack frame by executing the
	leave instruction (which restores the previous value of the base pointer and adjusts the stack pointer), and finally, the function returns.


_ZN1NC2Ei

	0x080486f6 <+0>:    push   %ebp
	0x080486f7 <+1>:    mov    %esp,%ebp
	These instructions set up the function's stack frame by pushing the value of the base pointer (%ebp) onto
	the stack and then moving the value of the stack pointer (%esp) into %ebp.
	-------------------------------------------------
	0x080486f9 <+3>:    mov    0x8(%ebp),%eax
	0x080486fc <+6>:    movl   $0x8048848,(%eax)
	These instructions move the value at address 0x8(%ebp) into %eax.
	It is likely that 0x8(%ebp) represents a pointer to an object of type N.
	Then, the value 0x8048848 is moved into the memory location pointed to by %eax.
	This could be initializing a member variable of the N object.
	-------------------------------------------------
	0x08048702 <+12>:   mov    0x8(%ebp),%eax
	0x08048705 <+15>:   mov    0xc(%ebp),%edx
	0x08048708 <+18>:   mov    %edx,0x68(%eax)
	These instructions again move the value at address 0x8(%ebp) into %eax, which likely represents the same object pointer.
	The value at address 0xc(%ebp) is moved into %edx, likely representing another value passed as an argument to the constructor.
	Then, the value in %edx is stored at offset 0x68 from the memory location pointed to by %eax.
	This could be setting another member variable of the N object.
	-------------------------------------------------
	0x0804870b <+21>:   pop    %ebp
	0x0804870c <+22>:   ret
	These instructions clean up the stack frame by popping the previous value of the base pointer from the stack (%ebp).
	Then, the ret instruction is executed to return from the function.
	-------------------------------------------------
	Based on this disassembled code, it appears that the function _ZN1NC2Ei is likely the constructor of a class N.
	It initializes some member variables and assigns values to them.
	-->		N(int arg) {
			*(int*)this = 0x8048848;	--> Address of the variable
			this->nb = arg;				--> number that we put in N. (Like this N(5) for example)
			}
	So We have something like this :
	--> N(int n) {
			nb = n;
		}

_ZN1N13setAnnotationEPc


	0x0804870e <+0>:    push   %ebp
	0x0804870f <+1>:    mov    %esp,%ebp
	These instructions are part of the function prologue.
	They save the previous base pointer %ebp on the stack by pushing its value, and then set %ebp to the current stack pointer %esp.
	This establishes a new stack frame for the function.
	-------------------------------------------------

	0x08048711 <+3>:    sub    $0x18,%esp
	This instruction adjusts the stack pointer %esp by subtracting 0x18 (24 in decimal) bytes.
	It reserves space on the stack for local variables or other temporary data.
	-------------------------------------------------

	0x08048714 <+6>:    mov    0xc(%ebp),%eax
	This instruction moves the value at address 0xc(%ebp) into the %eax register.
	%ebp+0xc likely corresponds to the first function parameter or a local variable.
	-------------------------------------------------

	0x08048717 <+9>:    mov    %eax,(%esp)
	This instruction moves the value in %eax onto the stack at the top of the current stack frame.
	-------------------------------------------------

	0x0804871a <+12>:   call   0x8048520 <strlen@plt>
	This instruction calls the strlen function, located at address 0x8048520.
	The argument for strlen is already on the stack. The return value of strlen will be stored in %eax.

	--> strlen(str)
	-------------------------------------------------

	0x0804871f <+17>:   mov    0x8(%ebp),%edx
	This instruction moves the value at address 0x8(%ebp) into the %edx register.
	%ebp+0x8 likely corresponds to the second function parameter or a local variable.
	-------------------------------------------------

	0x08048722 <+20>:   add    $0x4,%edx
	This instruction adds 0x4 (4 in decimal) to the value in %edx.
	-------------------------------------------------

	0x08048725 <+23>:   mov    %eax,0x8(%esp)
	This instruction moves the value in %eax onto the stack at an offset of 0x8 from the current top of the stack.
	-------------------------------------------------

	0x08048729 <+27>:   mov    0xc(%ebp),%eax
	This instruction moves the value at address 0xc(%ebp) into the %eax register.
	-------------------------------------------------

	0x0804872c <+30>:   mov    %eax,0x4(%esp)
	This instruction moves the value in %eax onto the stack at an offset of 0x4 from the current top of the stack.

	-------------------------------------------------
	0x08048730 <+34>:   mov    %edx,(%esp)
	This instruction moves the value in %edx onto the stack at the top of the current stack frame.
	-------------------------------------------------

	0x08048733 <+37>:   call   0x8048510 <memcpy@plt>
	This instruction calls the memcpy function, located at address 0x8048510.
	The arguments for memcpy are already on the stack.
	This function is likely used to copy data from one memory location to another.

	--> memcpy(tab, str, strlen(str)); ( look at the source_hex.c)
	-------------------------------------------------

	0x08048738 <+42>:   leave  
	This instruction is the reverse of the function prologue.
	It releases the current stack frame by restoring the previous base pointer %ebp and adjusts the stack pointer %esp accordingly.
	-------------------------------------------------

	0x08048739 <+43>:   ret  
	This instruction returns from the function, popping the return address from the stack.