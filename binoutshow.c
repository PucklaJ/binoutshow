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
#include <stdlib.h>
#include <string.h>
#include <binout.h>
#include <path.h>

/* Returns the suffix number of a string like d000101.
   If the given string is not such a string then -1 will be returned.*/
int get_d_string_number(const char* dstr) {
	if (strlen(dstr) != 7 || dstr[0] != 'd') {
		return -1;
	}

	return atoi(&dstr[1]);
}

int main(int args, char* argv[]) {
	if (args > 3 || args < 2) {
		fprintf(stderr, "invalid arguments\n");
		return 1;
	}

	const char* binout_file_name = argv[1];
	char* path_name = "/";

	if (args > 2) {
		path_name = argv[2];		
	}

	binout_file bin_file = binout_open(binout_file_name);
	char* open_error = binout_open_error(&bin_file);
	if (open_error) {
		fprintf(stderr, "failed to open binout: %s\n", open_error);
		free(open_error);
		binout_close(&bin_file);
		return 1;
	}

	size_t num_children;
	char** children = binout_get_children(&bin_file, path_name, &num_children);

	if (num_children == 0) {
		fprintf(stderr, "path %s has not been found\n", path_name);
		binout_close(&bin_file);
		return 1;
	}

	/* Get the path as path_t */
	path_t path_object, path_buffer;
	path_object.elements = path_elements(path_name, &path_object.num_elements);
	path_buffer.elements = NULL;
	path_buffer.num_elements = 0;

	int max_d_num = -1;
	
	size_t i = 0;
	while (i < num_children) {
		/* Parse children for special values like metadata and dxxxxxx */
		if (strcmp(children[i], "metadata") == 0) {
			/* Prepare the path */
			path_copy(&path_buffer, &path_object);
			path_join(&path_buffer, "metadata");
			char* path_buffer_str = path_str(&path_buffer);
			
			size_t num_metadata;
			char** metadata = binout_get_children(&bin_file, path_buffer_str, &num_metadata);
			
			free(path_buffer_str);

			printf("-- %s\n", children[i]);
			size_t j = 0;
			while (j < num_metadata) {
				printf("---- %s\n", metadata[j]);
			
				j++;
			}
			binout_free_children(metadata, num_metadata);
		} else {
			const int d_num = get_d_string_number(children[i]);
			if (d_num != -1) {
				if (d_num > max_d_num) {
					max_d_num = d_num;
				}
			} else {
				printf("-- %s\n", children[i]);
			}
		}
		
		i++;
	}
	binout_free_children(children, num_children);

	/* Now print all dxxxxxx values */
	if (max_d_num != -1) {
		/* Read the children from d000001*/
		path_free(&path_buffer);
		path_copy(&path_buffer, &path_object);
		path_join(&path_buffer, "d000001");
		char* path_buffer_str = path_str(&path_buffer);

		size_t num_d_children;
		char** d_children = binout_get_children(&bin_file, path_buffer_str, &num_d_children);
		free(path_buffer_str);

		printf("-- d000001 - d%06d\n", max_d_num);
		size_t j = 0;
		while (j < num_d_children) {
			printf("---- %s\n", d_children[j]);
		
			j++;
		}
		binout_free_children(d_children, num_d_children);
	}
	

	path_free(&path_object);
	path_free(&path_buffer);
	binout_close(&bin_file);
	return 0;
}
