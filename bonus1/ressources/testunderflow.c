#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	(void)argc;
	char dest[40]; // [esp+14h] [ebp-2Ch] BYREF
	int v5; // [esp+3Ch] [ebp-4h]

	v5 = atoi(argv[1]);
	printf("V5 = %d\n", v5);
	if ( v5 > 9 )
	{
		printf("V5 > 9 ...... Sorry\n");
		return 1;
	}
	memcpy(dest, argv[2], 4 * v5);
	printf("Dest = %s\n", dest);
	if ( v5 == 1464814662 )
		printf("Good\n");
  return 0;
}