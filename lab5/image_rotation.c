#include "image_rotation.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

RotatedImg* rotate_image_c(unsigned char* img, int w, int h, int ch, int angle)
{
	RotatedImg* result=(RotatedImg*)calloc(1, sizeof(RotatedImg));
	result->ch=ch;
	int offset=0;

	if(angle%90==0 && angle%180!=0) 
	{
		result->w=h;
		result->h=w;
	}
	else if(angle%180==0)
	{
		result->w=w;
		result->h=h;
	}
	else
	{
		result->w=4*w;
		result->h=4*h;
		offset=ch*(result->w/2)*(result->h/2)+ch*(result->w/2);
	}

	
	double radians=(double)(angle*M_PI)/180;

	size_t img_size=w*h*ch;
	size_t new_img_size=result->w*result->h*ch;
	unsigned char* new_img=(unsigned char*)calloc(new_img_size, sizeof(char));

	for(unsigned char* pixel=img; (pixel-img)<img_size; pixel+=ch)
	{
		int x=((pixel-img)/ch)%w;
		int y=((pixel-img)/ch)/w;
		int new_x=x*cos(radians)-y*sin(radians);
		int new_y=x*sin(radians)+y*cos(radians);
		/*if(cos(radians)!=(int)cos(radians) || sin(radians)!=(int)sin(radians))
		{
			if(x>0) x++;
			else x--;
			if(y>0) y++;
			else y--;
		}*/
		if(new_x<0 && (angle%90==0 || angle%180==0)) new_x=result->w+new_x;
		if(new_y<0 && (angle%90==0 || angle%180==0)) new_y=result->h+new_y;
		if(offset+result->w*new_y*ch+new_x*ch+2>new_img_size)
		{
			continue;
		}

		*(new_img+offset+result->w*new_y*ch+new_x*ch)=img[w*y*ch+x*ch];
		*(new_img+offset+result->w*new_y*ch+new_x*ch+1)=img[w*y*ch+x*ch+1];
		*(new_img+offset+result->w*new_y*ch+new_x*ch+2)=img[w*y*ch+x*ch+2];

		//printf("(new_x: %d ; new_y: %d) <- (x: %d ; y: %d)\n", new_x, new_y, x, y);
		//*new_pixel=img[w*y*ch+x*ch];
		//*(new_pixel+1)=img[w*y*ch+x*ch+1];
		//*(new_pixel+2)=img[w*y*ch+x*ch+2];
	}
	result->data=new_img;
	return result;
}
