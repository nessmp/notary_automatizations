#include "../include/read_validity.h"

#include <iostream>
#include <string>

ReadValidity::ReadValidity(
  const std::string &file_path, 
  const std::string &language) : ReadImage(file_path, language) {}

ReadValidity::~ReadValidity() {}

std::wstring ReadValidity::FindCic() {
    std::size_t cic_index = get_image_data().find(kCic_);
    if (cic_index != std::string::npos) {
        std::wstring substring = 
          get_image_data().substr(cic_index + kCic_.length());
        std::size_t eol_index = substring.find('\n');
        if (eol_index != std::string::npos) {
            return substring.substr(0, eol_index);
        }
    }

    return L"";
}

std::wstring ReadValidity::get_cic() const { return cic_; }

std::wstring ReadValidity::FindOcr() {
    std::size_t ocr_index = get_image_data().find(kOcr_);
    if (ocr_index != std::string::npos) {
        std::wstring substring = 
          get_image_data().substr(ocr_index + kOcr_.length());
        std::size_t eol_index = substring.find('\n');
        if (eol_index != std::string::npos) {
            return substring.substr(0, eol_index);
        }
    }

    return L"";
}

std::wstring ReadValidity::get_ocr() const { return ocr_; }

void ReadValidity::Execute() {
    ReadImage::Execute();

    cic_ = FindCic();
    ocr_ = FindOcr();
}

void ReadValidity::PrintValidationData() {
    std::wcout << L"----------------------------------------" << std::endl;
    std::wcout << L"Validation Data:" << std::endl;
    std::wcout << L"CIC: " << cic_ << std::endl;
    std::wcout << L"OCR: " << ocr_ << std::endl;
    std::wcout << L"----------------------------------------" << std::endl;
}
