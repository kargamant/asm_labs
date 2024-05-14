#pragma once

typedef struct RotatedImg
{
	int w, h, ch, offset;
	unsigned char* data;
}RotatedImg;
//angle in degrees
RotatedImg* rotate_image_c(unsigned char* img, int w, int h, int ch, int angle);
void rotate_image_asm(unsigned char* from, RotatedImg* to, int w, int h, int ch, int angle);
