#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

uint32_t language = 0;

int32_t greetuser()
{
	uint32_t eax = language;
	char var_4c[72];

	if (eax == 1)
	{
		char message[] = "Hyvää päivää ";
		__builtin_strcpy(var_4c, message);
		char var_3a_1 = 0;
	}
	else if (eax == 2)
	{
		char message[] = "Goedemiddag! ";
		__builtin_strcpy(var_4c, message);
	}
	else if (eax == 0)
	{
		char message[] = "Hello ";
		__builtin_strcpy(var_4c, message);
	}

	strcat(&var_4c, &arg_4);
	return puts(&var_4c);
}

int32_t main(int32_t argc, char** argv, char** envp)
{
	int32_t eax;

	if (argc != 3)
	{
		eax = 1;
	}
	else
	{
		char var_60[0x4c]; //76
		__builtin_memset(&var_60, 0, 0x4c);
		char* var_ac = argv[1];
		void* var_b0 = &var_60;
		strncpy(var_b0, var_ac, 0x28); //40

		var_ac = argv[2];
		char var_38[0x20]; //32
		var_b0 = &var_38;
		strncpy(var_b0, var_ac, 0x20); //32

		const char* env_var = "LANG";
		char* lang_value = getenv(env_var);

		if (lang_value != 0)
		{
			const char lang1[] = "fi";
			var_ac = lang_value;
			if (memcmp(var_ac, lang1, 2) == 0)
			{
				language = 1;
			}
			else
			{
				const char lang2[] = "nl";
				var_ac = lang_value;
				if (memcmp(var_ac, lang2, 2) == 0)
				{
					language = 2;
				}
			}
		}
		__builtin_memcpy(&var_b0, &var_60, 0x4c);
		eax = greetuser();
	}

	return eax;
}