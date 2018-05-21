#define _USE_MATH_DEFINES
#include <iostream>
#include <string>
#include <cmath>
#include "../Shared/dspf.hpp"

struct complex { 
	float Re, Im;
	complex operator= (float b) {
		Re = b; Im = 0;
		return *this;
	}
	complex operator+= (complex b) {
		Re += b.Re; Im += b.Im;
		return *this;
	}
	complex operator*=(complex b) {
		float x = Re, y = Im;
		Re = (x * b.Re) - (y * b.Im);
		Im = (x * b.Im) + (b.Re * y);
		return *this;
	}
};
complex operator* (complex a, complex b) {
	complex c = { 0, 0 };
	c.Re = (a.Re * b.Re) - (a.Im * b.Im);
	c.Im = (a.Re * b.Im) + (b.Re * a.Im);
	return c;
}
complex operator* (float a, complex b) {
	complex c = b;
	c.Re *= a; c.Im *= a;
	return c;
}
complex operator+ (complex a, complex b) {
	complex c = a;
	return c += b;
}
complex operator- (complex a, complex b) {
	complex c = a;
	return c += (-1.0f * b);
}
complex polar(double mag, double angle) {
	complex c = { 0, 0 };
	c.Re = (float)(mag * cos(angle));
	c.Im = (float)(mag * sin(angle));
	return c;
}

void tune(DSPFile& in, DSPFile& out, const float& station) {
	const float FS = 8.0f;
	const float FC = 94.8f;
	complex x[IOBUFFSIZE];
	unsigned long i = 0; // On the order of 75 million (int only goes up to about 4 million)

	/**
	 *  Attempts to optimize the loop
	 */
	// Attempt 1 - use fopen_s instead of std::fstream (see dspf.cpp)
	// Net Savings per loop: Uncertain

	// Attempt 2 - Move some multiplication out of the loop
	float prescale = (float)(-2 * M_PI * (station - FC) / FS); // Move some operations outside of the loop
	// Net Savings per loop: 2 mult ops, 1 divide op, 1 add op

	// Attempt 3 - Use periodicity of complex exponentials to precalculate values from sin/cos in polar()
	float precision = 0.0001f;
	std::vector<complex> periodicity;
	unsigned int n = 0; // n turns out to be on the order of 16,620
	periodicity.push_back(polar(1, prescale * n++));
	while (true) {
		periodicity.push_back(polar(1, prescale * n));
		complex diff = periodicity[n++] - periodicity[0];
		if (abs(diff.Re) < precision && abs(diff.Im) < precision) {
			break;
		}
	}
	// Net Savings per loop: 3 mult ops, 2 func calls (sin/cos ops, probably table-lookup based), 2 assign ops

	/**
	*  All the above efforts don't seem to have made a significant impact on time to process 600MB file
	*/

	// Attempt 4 - change IOBUFFSIZE from 1024 -> 32768 (ok, we have impact now)
	// Result: Processing time reduced from ~10 minutes to ~1 minute

	// Attempt 5 - Revert back to std::fstream since it did not improve after attempt 1
	// Result: We're back at the old speed all the sudden....wth?!

	/**
	 *  End optimization attemps
	 */

	int xlen = in.read_n((float*)x, 100 * 2) / 2; // Skip the first garbage 100 samples
	if (xlen == 100) {
		xlen = in.read_n((float*)x, IOBUFFSIZE * 2) / 2;
		while (xlen > 0) {
			for (int j = 0; j < xlen; ++j) {
				// Performance breakdown:
				// 1 mod op, 2 access ops, 4 mult ops, 2 add ops, 1 func call, 2 float alloc, 2 assign op
				x[j] *= periodicity[i++ % n]; // polar(1, 2pi(ft-fc)/fs * i++)
			}
			out.write_d((float*)x, xlen * 2);
			xlen = in.read_n((float*)x, IOBUFFSIZE * 2) / 2;
		}
	} else {
		std::cout << "Invalid input signal file..." << std::endl;
	}
}

void resample(const dsig& hsig, const int& U, const int& D, DSPFile& in, DSPFile& out) {
	// Determine bounds on computed arrays
	const int L = (int)hsig.size();

	// Adjust the header on the output file
	out.Header = in.Header;
	out.Header.dim0 = (out.Header.dim0 * U) / D;
	out.Header.dim1 = (out.Header.dim1 * U) / D;
	out.write_h();

	// It would be really nice if Dr. Gunther explained in his slides what the heck this is...
	int M = L / U + ((L % U) > 0);
	int N = M * U; // Padded impulse response length

	int d = 0, k = 0;
	complex* x = new complex[L];
	const float* h = hsig.data();
	complex
		xbuff[IOBUFFSIZE],
		ybuff[IOBUFFSIZE];

	// Zero out circular buffer to clear garbage
	for (int i = 0; i < M; ++i) { x[i] = 0; }

	//x[i] = in.read_1();
	int xlen = in.read_n((float*)xbuff, IOBUFFSIZE * 2) / 2;
	int ylen = 0;
	while (xlen > 0) {
		for (int i = 0; i < xlen; ++i) {
			k = (k + M - 1) % M;
			x[k] = xbuff[i];

			if (d == 0) { // Downsampling discards D - 1 values
				for (int j = 0; j < U; ++j) {
					complex y = { 0, 0 }; int m = 0, n = 0;
					// Upsampling creates 0 every U elements of x (skipping over h because convolution is associative)
					for (; n < M; ++n, m += U) {
						y += h[m + j] * x[(n + k) % M];
					}
					ybuff[ylen++] = y;
					if (ylen == IOBUFFSIZE) {
						out.write_d((float*)ybuff, ylen * 2);
						ylen = 0;
					}
				}
				d = D - 1;
			} else { --d; }
		}

		xlen = in.read_n((float*)xbuff, IOBUFFSIZE * 2) / 2;
	}
	if (ylen > 0) {
		out.write_d((float*)ybuff, ylen * 2);
		ylen = 0;
	}

	delete[] x;
}

int main() {
	float station = 96.7f;
	std::string
		f_h1 = "output\\h1.bin",
		f_h2 = "output\\h2.bin",
		f_h3 = "output\\h3.bin",
		f_h4 = "output\\h4.bin",
		f_h5 = "output\\h7.bin",
		f_radio = "output\\freq94_8_bw_4.bin",
		f_y0 = "output\\y0.bin",
		f_y1 = "output\\y1.bin",
		f_y2 = "output\\y2.bin",
		f_y3 = "output\\y3.bin",
		f_y4 = "output\\y4.bin",
		f_x = "output\\x.bin",
		f_r1 = "output\\r1.bin",
		f_r2 = "output\\r2.bin",
		f_r3 = "output\\r3.bin";
	DSPFile
		fin(DSP::Mode::Read | DSP::Mode::NoHeader),
		fout(DSP::Mode::Write | DSP::Mode::NoHeader),
		fh1(f_h1, DSP::Mode::Read),
		fh2(f_h2, DSP::Mode::Read),
		fh3(f_h3, DSP::Mode::Read),
		fh4(f_h4, DSP::Mode::Read),
		fh5(f_h5, DSP::Mode::Read);
	dsig
		h1 = fh1.read_all(),
		h2 = fh2.read_all(),
		h3 = fh3.read_all(),
		h4 = fh4.read_all(),
		h5 = fh5.read_all();

	fout.close();
	fin.open(f_radio); fout.open(f_y0);
	tune(fin, fout, station);

	fout.close();
	fin.open(f_y0); fout.open(f_y1);
	resample(h1, 1, 2, fin, fout);

	fout.close();
	fin.open(f_y1); fout.open(f_y2);
	resample(h2, 1, 2, fin, fout);

	fout.close();
	fin.open(f_y2); fout.open(f_y3);
	resample(h3, 1, 2, fin, fout);

	fout.close();
	fin.open(f_y3); fout.open(f_y4);
	resample(h4, 1, 2, fin, fout);

	fout.mode(DSP::Mode::Write);
	fin.open(f_x); fout.open(f_r1);
	fin.Header = {1, 1, 4789058, 500000, 0 }; // Hard coded because the values are known and running out of time
	resample(h5, 1, 2, fin, fout);

	fin.mode(DSP::Mode::Read); fout.close();
	fin.open(f_r1); fout.open(f_r2);
	resample(h5, 3, 5, fin, fout);

	fout.close();
	fin.open(f_r2); fout.open(f_r3);
	resample(h5, 1, 5, fin, fout);

	system("pause");
	return 0;
}
