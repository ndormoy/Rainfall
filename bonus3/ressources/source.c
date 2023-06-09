#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    int i;
    int iVar;
    FILE *file;
    unsigned char buffer[66];
    unsigned int localVars[16];
    
    file = fopen("/home/user/end/.pass", "r");
    
    for (i = 0; i < 16; i++)
    {
        localVars[i] = 0;
    }
    
    if (file == NULL || argc != 2)
    {
        return -1;
    }
    
    fread(localVars, sizeof(unsigned int), 33, file);
    
    fclose(file);
    
    iVar = atoi(argv[1]);
    localVars[iVar] = 0;
    
    file = fopen("/home/user/end/.pass", "r");
    fread(buffer, sizeof(unsigned char), 65, file);
    fclose(file);
    
    iVar = strcmp((char *)localVars, argv[1]);
    
    if (iVar == 0)
    {
        execl("/bin/sh", "sh", 0);
    }
    else
    {
        printf("%s\n", buffer);
    }
    
    return 0;
}