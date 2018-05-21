#include <iostream>
#include "../Shared/dspf.hpp"

const std::string filter = "lpf_260_400_44100_80db.bin";
const std::string firefly = "output\\fireflyintro.bin";
const std::string firepfp = "output\\fireflyintro_pfp.bin";
const std::string firertp = "output\\fireflyintro_rtp.bin";
const std::string img1 = "output\\cameraman.bin";
const std::string img1_out = "output\\cameraman_edge.bin";
const std::string img2 = "output\\John Fiddle.bin";
const std::string img2_out = "output\\John Fiddle.bin";

void audio_full() {
	DSPFile
		fin(firefly),
		lpf(filter),
		fout(firepfp, DSP::Mode::Write);

	if (!fin.ready() || !lpf.ready() || !fout.ready()) {
		return;
	}

	dsig h = lpf.read_all();
	dsig x = fin.read_all();

	int h_size = h.size(),
		d_size = x.size(),
		o_size = d_size + (h_size - 1);

	dsig out(o_size, 0);
	fout.Header = fin.Header;
	fout.Header.dim0 = o_size;

	// Apparently array access on vectors is ridiculously slow (visual studio compiler)
	float
		* pout = out.data(),
		* ph = h.data(),
		* px = x.data();

	for (int j = 0; j < h_size; ++j) {
		if (ph[j] == 0) { continue; }
		for (int i = 0; i < o_size; ++i) {
			if (!(i - j < d_size)) { break; }
			if (!(i - j < 0)) {
				pout[i] += ph[j] * px[i - j];
			}
		}
	}

	fout.write_h();
	fout.write_d(out.data(), o_size);
}

void audio_realtime() {
	DSPFile
		fin(firefly),
		lpf(filter),
		fout(firertp, DSP::Mode::Write);

	dsig h = lpf.read_all();

	int buf = h.size();
	dsig x(buf, 0);

	// Fix the header
	fout.Header = fin.Header;
	//fout.Header.dim0; // The circular buffer chops the tails
	fout.write_h();

	// Apparently array access on vectors is ridiculously slow (visual studio compiler)
	float
		* ph = h.data(),
		* px = x.data();

	int k, i = buf - 1;
	px[i] = fin.read_1();
	while (fin.ready()) {
		float y = 0;
		for (k = 0; k < buf; ++k) {
			y += ph[k] * px[(k + i) % buf];
		}
		i = (i + buf - 1) % buf;

		fout.write_d(y);
		px[i] = fin.read_1();
	}
}

float* conv2(const float* x, int mx, int nx, const float* h, int mh, int nh) {

}

void image_grayscale() {
	DSPFile
		fin(img1),
		fout(img1_out, DSP::Mode::Write);

	dsig x = fin.read_all();

}

void image_color() {

}

int main() {
	//audio_full();
	//audio_realtime();
	image_grayscale();

	system("pause");
	return 0;
}
