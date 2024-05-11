#pragma once

typedef struct RotatedImg
{
	int w, h, ch;
	unsigned char* data;
}RotatedImg;
//angle in degrees
RotatedImg* rotate_image_c(unsigned char* img, int w, int h, int ch, int angle);
