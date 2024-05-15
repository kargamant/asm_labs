#include <stdlib.h>
#include <stdio.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image_sources/stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_sources/stb/stb_image_write.h"
#include "image_rotation.h"
#include <time.h>
#include <stddef.h>

int main(int argc, char* argv[])
{
	//parcing params
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
	else if(argc==3)
	{
		fprintf(stderr, "Error. No angle was specified.\n");
		return 1;
	}
	int angle=atoi(argv[3]);
	unsigned char* image=stbi_load(argv[1], &w, &h, &ch, 0);
	if(image==NULL)
	{
		fprintf(stderr, "Error. Incorrect input filename.\n");
		return 1;
	}

	
	//C program
	clock_t start=clock();
	RotatedImg* result=rotate_image_c(image, w, h, ch, angle);
	clock_t finish=clock();
	printf("C prog time: %ld milliseconds\n", ((finish-start)*1000)/CLOCKS_PER_SEC);
	free(result->data);


	//asm program
	result->data=(unsigned char*)calloc(result->w*result->h*ch, sizeof(char));
	
//	printf("w: %d, offsetof: %d\n", result->w, offsetof(RotatedImg, w));
//	printf("h: %d, offsetof: %d\n", result->h, offsetof(RotatedImg, h));
//	printf("ch: %d, offsetof: %d\n", result->ch, offsetof(RotatedImg, ch));
//	printf("offset: %d, offsetof: %d\n", result->offset, offsetof(RotatedImg, offset));
//	printf("data: %p, offsetof: %d\n", result->data, offsetof(RotatedImg, data));
//	printf("image: %p\n", image);
	
	
	start=clock();
	rotate_image_asm(image, result, w, h, ch, angle);
	finish=clock();
	printf("Asm prog time: %ld milliseconds\n", ((finish-start)*1000)/CLOCKS_PER_SEC);
	
	//stbi_write_jpg(argv[2], w, h, ch, image, 100);
	//writing result
	int res=stbi_write_jpg(argv[2], result->w, result->h, result->ch, result->data, 100);

	stbi_image_free(image);
	free(result->data);
	return 0;
}
