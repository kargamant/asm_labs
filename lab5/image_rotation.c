#include "image_rotation.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

unsigned char* rotate_image_c(unsigned char* img, int w, int h, int ch, int angle)
{
	double radians=(double)(angle*3.14159)/180;

	size_t img_size=w*h*ch;
	unsigned char* new_img=(unsigned char*)calloc(img_size, sizeof(char));
	for(unsigned char* pixel=new_img; (pixel-new_img)<img_size; pixel+=ch)
	{
		int new_x=((pixel-new_img)/ch)%w;
		int new_y=((pixel-new_img)/ch)/w;
		int x=new_x*cos(radians)-new_y*sin(radians);
		int y=new_x*sin(radians)+new_y*cos(radians);
		if(w*y*ch+x*ch<0 || w*y*ch+x*ch+2>img_size) continue;
		//printf("(new_x: %d ; new_y: %d) <- (x: %d ; y: %d)\n", new_x, new_y, x, y);
		*pixel=img[w*y*ch+x*ch];
		*(pixel+1)=img[w*y*ch+x*ch+1];
		*(pixel+2)=img[w*y*ch+x*ch+2];
	}
	return new_img;
}
