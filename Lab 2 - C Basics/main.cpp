#include <iostream>
#include <fstream>
#include <string>
#include <vector>

typedef std::vector<float> dsd;
struct dsh { int ndim, nchan, dim0, dim1, dim2; };

//--------------------------------------------------------------------------------------+
// Reads a full binary file into reference passed header and vector<float>              |
//--------------------------------------------------------------------------------------+
bool getData(const std::string file, dsh& header, dsd& data) {
	float temp;
	std::fstream fin(file, std::ios::in | std::ios::binary);

	if (!fin) {
		std::cout << "Error fetching: " << file << std::endl;
		fin.close();
		return false;
	}

	fin.read(reinterpret_cast<char*>(&header), sizeof(dsh));
	while (!fin.eof()) {
		fin.read(reinterpret_cast<char*>(&temp), sizeof(float));
		data.push_back(temp);
	}
	fin.close();
	return true;
}

void parta() {
	int n;
	dsh h;
	dsd d1, d2;
	const std::string
		f1 = "output\\f1.bin",
		f2 = "output\\f2.bin",
		f3 = "output\\f3.bin";

	// Read f1 and f2
	if (!getData(f1, h, d1)) { return; }
	if (!getData(f2, h, d2)) { return; }

	// Create a coalesced form
	h.nchan = 2;
	n = d1.size();
	float* d3 = new float[2 * n];
	for (int i = 0; i < n; ++i) {
		d3[(2 * i)] = d1[i];
		d3[(2 * i) + 1] = d2[i];
	}

	// Write out the coalesced file
	std::fstream fout(f3, std::ios::out | std::ios::binary | std::ios::trunc);
	fout.write(reinterpret_cast<char*>(&h), sizeof(dsh));
	fout.write(reinterpret_cast<char*>(d3), sizeof(float) * 2 * n);
	fout.close();

	// Free up dynamically allocated memory
	delete[] d3;
}

void partb() {
	int n;
	dsh h;
	dsd d1;
	const std::string
		f1 = "output\\xylophone.bin",
		f2 = "output\\xylophone_gray.bin";

	// Read f1
	if (!getData(f1, h, d1)) { return; }

	// Create a grayscale version
	h.nchan = 1;
	n = d1.size() / 3;
	float* d2 = new float[n];
	for (int i = 0; i < n; ++i) {
		d2[i] =
			(0.2989 * d1[(3 * i) + 0]) + // Red
			(0.5870 * d1[(3 * i) + 1]) + // Green
			(0.1140 * d1[(3 * i) + 2]);  // Blue
	}

	// Write out f2
	std::fstream fout(f2, std::ios::out | std::ios::binary | std::ios::trunc);
	fout.write(reinterpret_cast<char*>(&h), sizeof(dsh));
	fout.write(reinterpret_cast<char*>(d2), sizeof(float) * n);
	fout.close();

	// Free up dynamically allocated memory
	delete[] d2;
}

int main() {
	//parta();
	partb();

	system("pause");
	return 0;
}
