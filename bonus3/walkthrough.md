After decompile the executable with dogbolt, we used mainly the code from ghidra. after we pass it through chatgpt for better reading, but still of some things to fix.

Then we look at the code find that if put an empty string in input, the atoi return 0 so localvar[0] = 0.

then the return of strcmp (iVar) is equal to 0 because there is nothing to compare because s2 is an empty string and localvar = 0.

So it opens /bin/sh:

bonus3@RainFall:~$ ./bonus3 ""
$ cat /home/user/end/.pass
3321b6f81659f9a71c76616f606e4b50189cecfea611393d5d649f75e157353c