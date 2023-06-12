
int32_t frame_dummy()
{
	return __JCR_END__;
}

int32_t greetuser()
{
	uint32_t eax = language;
	int32_t var_4c;
	if (eax == 1)
	{
		__builtin_memcpy(var_4c, "Hyv\xc3\xa4\xc3\xa4 p\xc3\xa4iv\xc3\xa4\xc3\xa4 ", 0x12);
		char var_3a_1 = 0;
	}
	else if (eax == 2)
	{
		__builtin_strcpy(var_4c, "Goedemiddag! ");
	}
	else if (eax == 0)
	{
		__builtin_strncpy(var_4c, "Hello ", 7);
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
		void var_60;
		__builtin_memset(&var_60, 0, 0x4c);
		char* var_ac = argv[1];
		void* var_b0 = &var_60;
		strncpy(var_b0, var_ac, 0x28);
		var_ac = argv[2];
		void var_38;
		var_b0 = &var_38;
		strncpy(var_b0, var_ac, 0x20);
		var_b0 = "LANG";
		char* eax_7 = getenv("LANG");
		if (eax_7 != 0)
		{
			var_ac = &data_804873d;
			var_b0 = eax_7;
			if (memcmp(var_b0, &data_804873d, 2) == 0)
			{
				language = 1;
			}
			else
			{
				var_ac = &data_8048740;
				var_b0 = eax_7;
				if (memcmp(var_b0, &data_8048740, 2) == 0)
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


