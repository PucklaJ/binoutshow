/***********************************************************************************
 *                         This file is part of binoutshow
 *                    https://github.com/PucklaMotzer09/binoutshow
 ***********************************************************************************
 * Copyright (c) 2022 PucklaMotzer09
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution.
 ************************************************************************************/

#include <stdio.h>
#include <binout.h>

int main(int args, char* argv[]) {
	if (args != 2) {
		fprintf(stderr, "invalid arguments\n");
		return 1;
	}

	const char* binout_file_name = argv[1];

	binout_file bin_file = binout_open(binout_file_name);
	char* open_error = binout_open_error(&bin_file);
	if (open_error) {
		fprintf(stderr, "failed to open binout: %s\n", open_error);
		free(open_error);
		binout_close(&bin_file);
		return 1;
	}

	size_t num_children;
	char** children = binout_get_children(&bin_file, "/", &num_children);

	printf("---- Children: %d ----\n", num_children);
	size_t i = 0;
	while (i < num_children) {
		printf("-- %s\n", children[i]);
		
		i++;
	}
	printf("----------------------\n");
	binout_free_children(children, num_children);

	binout_close(&bin_file);
	return 0;
}
