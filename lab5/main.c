#include <stdlib.h>
#include <stdio.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image_sources/stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_sources/stb/stb_image_write.h"

int main(int argc, char* argv[])
{
	int w, h, ch;
	if(argc==1)
	{
		fprintf(stderr, "Error. No input filename was specified.\n");
		return 1;
	}
	else if(argc==2)
	{
		fprintf(stderr, "Error. No output filename was specified.\n");
		return 1;
	}
	unsigned char* image=stbi_load(argv[1], &w, &h, &ch, 0);
	if(image==NULL)
	{
		fprintf(stderr, "Error. Incorrect input filename.\n");
		return 1;
	}

	int res=stbi_write_jpg(argv[2], w, h, ch, image, 100);
	//printf("res:%d\n", res);
	stbi_image_free(image);
	return 0;
}
