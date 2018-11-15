#include <stdint.h>

typedef struct filter_lp1 {
    float x;   // destination
    float y;
    float c;
} filter_lp1_t;

int main( void )
{
    return 1;
}
float _lp_sample(filter_lp1_t* f, float in)
{
	f->y = f->y + f->c * (in - f->y);
	return f->y;
}

float* lp1_sample(filter_lp1_t* f, float* in, float* out, uint16_t size)
{
    float* out2=out;
    for(int i=0;i<size;i++){
        *out2++ = _lp_sample(f, *in++);
    }
    return out;
}

float* lp1_block(filter_lp1_t* f, float* in, float* out, uint16_t size)
{
	float* in2=in;
	float* out2=out;
	float* out3=out; // point to start of arrays
	// out3 = y = previous OUT

	// first samp
	*out2++ = f->y + f->c * ((*in2++) - f->y);

	// remainder of samps -> add nFloor early exit to avoid denormals
	for(uint16_t i=0; i<(size-1); i++) {
		*out2++ = (*out3) + f->c * ((*in2++) - (*out3));
		out3++;
	}

	f->y = *out3; // last output
    return out;
}
