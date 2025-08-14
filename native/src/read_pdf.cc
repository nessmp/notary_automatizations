#include "../include/read_pdf.h"

#include <pdfio.h>
#include <string.h>

#include <iostream>
#include <vector>

ReadPdf::ReadPdf(const std::string &file_path) {
    file_path_ = file_path;
    file_ = pdfioFileOpen(
      file_path_.c_str(), NULL, NULL, NULL, NULL);
}

ReadPdf::~ReadPdf() {
    pdfioFileClose(file_);
}

std::wstring ReadPdf::file_data() const { return file_data_; }

std::wstring ReadPdf::NormalizeFileData(const std::string &file_data) {
    std::wstring normalized(file_data.begin(), file_data.end());
    for (size_t i = 0; i < file_data.length(); i++) {
        int ascii_code = int(file_data[i]);
        if (int(file_data[i]) < 0) {
            normalized[i] = static_cast<unsigned char>(255 + ascii_code + 1);
        }
    }

    return normalized;
}

std::string ReadPdf::ReadFileData() {
    // Number of pages.
    size_t num_pages = pdfioFileGetNumPages(file_);
    std::vector<unsigned char> text = {};
    std::string data = "";

    for (size_t i = 0; i < num_pages; i++) {
        // Current page object.
        pdfio_obj_t *obj = pdfioFileGetPage(file_, i);
        if (obj == NULL) {
            continue;
        }

        // Number of streams for page.
        size_t num_streams = pdfioPageGetNumStreams(obj);
        for (size_t j = 0; j < num_streams; j ++) {
            // Current page content stream.
            pdfio_stream_t *content_stream= pdfioPageOpenStream(obj, j, true);
            if (content_stream  == NULL) {
                continue;
            }

            // First string token.
            bool first = true;
            // String buffer.
            char buffer[1024];
            while (
              pdfioStreamGetToken(content_stream, buffer, sizeof(buffer))) {
                if (buffer[0] == '(') {
                    if (first) {
	                    first = false;
                    } else {
                        data += ' ';
                    }
                    data += buffer + 1;
                } else if (!strcmp(buffer, "Td") || 
                           !strcmp(buffer, "TD") || 
                           !strcmp(buffer, "T*") || 
                           !strcmp(buffer, "\'") || 
                           !strcmp(buffer, "\"")) {
                    data += '\n';
                    first = true;
                }
            }

            if (!first) {
                data += '\n';
            }

            pdfioStreamClose(content_stream);
        }
    }

    return data;
}

void ReadPdf::Execute() {
    file_data_ = NormalizeFileData(ReadFileData());
}

void ReadPdf::PrintFileData() {
    std::wcout << file_data_ << std::endl;
}
