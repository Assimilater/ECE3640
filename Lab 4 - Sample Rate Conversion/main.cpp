#include <iostream>
#include <string>
#include "../Shared/dspf.hpp"

void resample(dsig hsig, int U, int D, DSPFile& in, DSPFile& out) {
	// Determine bounds on computed arrays
	const int L = (int)hsig.size();
	const int IOBUFFSIZE = 1024;

	// Adjust the header on the output file
	out.Header = in.Header;
	out.Header.dim0 = (out.Header.dim0 * U) / D;
	out.Header.dim1 = (out.Header.dim1 * U) / D;
	out.write_h();

	// It would be really nice if Dr. Gunther explained in his slides what the heck this is...
	int M = L / U + ((L % U) > 0);
	int N = M * U; // Padded impulse response length

	int d = 0, k = 0;
	float* x = new float[L];
	float* h = hsig.data();
	float
		xbuff[IOBUFFSIZE],
		ybuff[IOBUFFSIZE];

	// Zero out circular buffer to clear garbage
	for (int i = 0; i < M; ++i) { x[i] = 0; }

	//x[i] = in.read_1();
	int xlen = in.read_n(xbuff, IOBUFFSIZE);
	int ylen = 0;
	while (xlen > 0) {
		for (int i = 0; i < xlen; ++i) {
			k = (k + M - 1) % M;
			x[k] = xbuff[i];

			if (d == 0) { // Downsampling discards D - 1 values
				for (int j = 0; j < U; ++j) {
					float y = 0.0; int m = 0, n = 0;
					// Upsampling creates 0 every U elements of x (skipping over h because convolution is associative)
					for (; n < M; ++n, m += U) {
						y += h[m + j] * x[(n + k) % M];
					}
					ybuff[ylen++] = y;
					if (ylen == IOBUFFSIZE) {
						out.write_d(ybuff, ylen);
						ylen = 0;
					}
				}
				d = D - 1;
			} else { --d; }
		}

		xlen = in.read_n(xbuff, IOBUFFSIZE);
	}
	if (ylen > 0) {
		out.write_d(ybuff, ylen);
		ylen = 0;
	}

	delete[] x;
	//delete[] h;
}

int main() {
	int argc = 6;
	const char* argv[6] = { "Lab 4.exe",
		"output\\lpf_xn.bin",
		"output\\lpf_hn.bin",
		"output\\galway11_Test.bin",
		"1", "2" };

//int main(int argc, char** argv) {
	int U, D;
	std::string h, in, out;

	if (argc != 6) {
		std::cout << "Invalid Args" << std::endl;
		system("pause");
		return -1;
	}

	h = std::string(argv[1]);
	in = std::string(argv[2]);
	out = std::string(argv[3]);
	U = atoi(argv[4]);
	D = atoi(argv[5]);
	
	DSPFile lpf(h), fin(in), fout(out, DSP::Mode::Write);
	resample(lpf.read_all(), U, D, fin, fout);

	system("pause");
	return 0;
}
