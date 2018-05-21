#pragma once
#include <string>
#include <memory>
#include <vector>
#include <stdio.h>
//#include <fstream>
#define IOBUFFSIZE 32768

namespace DSP {
	enum Mode { Read = 1, Write = 2, RealTime = 4, NoHeader = 8, };
	enum Type { Audio = 1, Image = 2, Video = 3 };
	struct color { float r, g, b; };
	static float gray(color c) {
		return (0.2989f * c.r) + (0.5870f * c.g) + (0.1140f * c.b);
	};
}

typedef std::vector<float> dsig;
typedef std::vector<DSP::color> dpix;
typedef std::vector<std::vector<float>> dsig_block;
typedef std::vector<std::vector<DSP::color>> dpix_block;
struct dsh { int ndim, nchan, dim0, dim1, dim2; };

class DSPFile {
private:
	bool valid = true;
	std::string file;
	FILE* fid;
	//std::fstream fid;
	int fmode;

public:
	dsh Header;
	bool open(std::string);

	~DSPFile() { close(); }
	DSPFile(int fm = DSP::Mode::Read) { mode(fm); }
	DSPFile(std::string f, int fm = DSP::Mode::Read) { open(f, fm); };
	bool open(std::string f, int fm) { mode(fm); return open(f); };
	void close() { 
		if (fid != NULL) {
			fclose(fid);
		}
		valid = false;
		fid = NULL;
	};
	//void close() { fid.close(); valid = false; };
	void mode(int fm) { fmode = fm; }
	bool ready() { return valid; }

	int read_n(float*, int);
	float read_1();
	dsig read_all();

	void write_h();
	void write_d(float*, int);
	void write_d(float);
};
