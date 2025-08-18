#include "../include/read_image.h"

#include <tesseract/baseapi.h>
#include <leptonica/allheaders.h>

#include <iostream>

ReadImage::ReadImage(
  const std::string &file_path, 
  const std::string &language) {
    file_path_ = file_path;
    language_ = language;
}

ReadImage::~ReadImage() {}

void ReadImage::Execute() {
    char *outText;
    api_ = new tesseract::TessBaseAPI();
    if (api_->Init(NULL, language_.c_str())) {
        std::wcout << L"Error Initiating tesseract" << std::endl;
    } else {
        image_ = pixRead(file_path_.c_str());
        api_->SetImage(image_);
        outText = api_->GetUTF8Text();

        std::size_t len = std::mbstowcs(nullptr, outText, 0) + 1;
        std::wstring image_text(len, L'\0');
        std::mbstowcs(&image_text[0], outText, len);

        delete [] outText;
        pixDestroy(&image_);

        image_data_ = image_text;
    }
    // Destroy used object and release memory.
    api_->End();
    delete api_;
}

std::string ReadImage::get_file_path() const { return file_path_; }

std::wstring ReadImage::get_image_data() const { return image_data_; }

void ReadImage::PrintImageData() {
    std::wcout << L"----------------------------------------" << std::endl;
    std::cout << "Image Data: on dir: " << file_path_ << std::endl;
    std::wcout << image_data_ << std::endl;
    std::wcout << L"----------------------------------------" << std::endl;
}
