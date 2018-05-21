#include "dspf.hpp"
#include <iostream>
#include <errno.h>
using namespace DSP;

bool DSPFile::open(std::string f) {
	close();
	file = f;

	std::string mode = "b";
	if (fmode & Mode::Read) {
		mode = "r" + mode;
	}
	if (fmode & Mode::Write) {
		mode = "w" + mode;
	}

	errno_t err;
	if ((err = fopen_s(&fid, f.c_str(), mode.c_str())) != 0) {
		std::cout << "Error fetching " << file << "." << std::endl;
		return valid = false;
	}

	if ((fmode & Mode::Read) && !(fmode & Mode::NoHeader)) {
		fread((dsh*)(&Header), sizeof(dsh), 1, fid);
	}
	return valid = true;
}

//bool DSPFile::open(std::string f) {
//	close();
//
//	file = f;
//	int mode = std::ios::binary;
//
//	if (fmode & Mode::Read) {
//		mode |= std::ios::in;
//	}
//	if (fmode & Mode::Write) {
//		mode |= std::ios::out | std::ios::trunc;
//	}
//
//	fid = std::fstream(file, mode);
//	if (!fid) {
//		std::cout << "Error fetching: " << file << std::endl;
//		return valid = false;
//	}
//
//	if ((fmode & Mode::Read) && !(fmode & Mode::NoHeader)) {
//		fid.read(reinterpret_cast<char*>(&Header), sizeof(dsh));
//	}
//	return valid = true;
//}

int DSPFile::read_n(float* data, int n) {
	return fread(data, sizeof(float), n, fid);
	//fid.read(reinterpret_cast<char*>(data), sizeof(float) * n);
	//return (int)(fid.gcount() / sizeof(float));
}

float DSPFile::read_1() {
	float data;
	valid &= (fread(&data, sizeof(float), 1, fid) == 0);
	//fid.read(reinterpret_cast<char*>(&data), sizeof(float));
	//valid &= !fid.eof();
	return data;
}

dsig DSPFile::read_all() {
	dsig data; int n;
	float x[IOBUFFSIZE];
	while (true) {
		n = read_n(x, IOBUFFSIZE);
		if (n == 0) { break; }
		data.insert(data.end(), x, x + n);
	}
	close();

	return data;
}

void DSPFile::write_h() {
	if (fmode & Mode::NoHeader) { return; }
	fwrite(&Header, sizeof(dsh), 1, fid);
	//fid.write(reinterpret_cast<char*>(&Header), sizeof(dsh));
}

void DSPFile::write_d(float* data, int n) {
	fwrite(data, sizeof(float), n, fid);
	//fid.write(reinterpret_cast<char*>(data), sizeof(float) * n);
}
void DSPFile::write_d(float data) {
	fwrite(&data, sizeof(float), 1, fid);
	//fid.write(reinterpret_cast<char*>(&data), sizeof(float));
}
