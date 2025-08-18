#ifndef READIMAGE_H
#define READIMAGE_H

#include <tesseract/baseapi.h>
#include <leptonica/allheaders.h>

class ReadImage {
    public:
        ReadImage(
          const std::string &file_path,
          const std::string &language = "eng");
        ~ReadImage();

        std::string get_file_path() const;
        std::wstring get_image_data() const;
        virtual void Execute();
        void PrintImageData();

        // ReadImage() = default;

    private:
        Pix *image_;
        std::string file_path_;
        std::string language_;
        std::wstring image_data_;
        tesseract::TessBaseAPI *api_;

        ReadImage(const ReadImage &) = delete;
        ReadImage &operator=(const ReadImage &) = delete;
};

#endif // READIMAGE_H
