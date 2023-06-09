int32_t main(int32_t argc, char** argv, char** envp)
{
	FILE* eax = fopen("/home/user/end/.pass", &data_80486f0);
	void var_98;
	__builtin_memset(&var_98, 0, 0x84);
	int32_t eax_1;
	if ((eax == 0 || (eax != 0 && argc != 2)))
	{
		eax_1 = 0xffffffff;
	}
	if ((eax != 0 && argc == 2))
	{
		fread(&var_98, 1, 0x42, eax);
		char var_57_1 = 0;
		*(&var_98 + atoi(argv[1])) = 0;
		void var_56;
		fread(&var_56, 1, 0x41, eax);
		fclose(eax);
		if (strcmp(&var_98, argv[1]) != 0)
		{
			puts(&var_56);
		}
		else
		{
			execl("/bin/sh", &data_8048707, 0);
		}
		eax_1 = 0;
	}
	return eax_1;
}