#ifndef READINEVALIDATION_H
#define READINEVALIDATION_H

#include "read_image.h"

class ReadValidity : public ReadImage {
    public:
        ReadValidity(
          const std::string &file_path,
          const std::string &language = "eng");
        ~ReadValidity();

        void Execute() override;
        void PrintValidationData();

        std::wstring get_cic() const;
        std::wstring get_ocr() const;

    private:
        std::wstring FindCic();
        std::wstring FindOcr();
        
        std::wstring cic_;
        std::wstring ocr_;
        
        // TODO: Move all the constants somewhere else.
        const std::wstring kCic_ = L"CIC ";
        const std::wstring kOcr_ = L"OCR ";

        // Disallow copying
        ReadValidity(const ReadValidity &) = delete;
        ReadValidity &operator=(const ReadValidity &) = delete;
};

#endif // READINEVALIDATION_H