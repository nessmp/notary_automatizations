#ifndef READPDF_H
#define READPDF_H

#include <pdfio.h>

#include <string>

class ReadPdf {
    public:
        ReadPdf(const std::string &file_path);
        ~ReadPdf();

        std::wstring file_data() const;
        virtual void Execute();
        void PrintFileData();

    private:
        pdfio_file_t *file_;
        std::string file_path_;
        std::wstring file_data_;

        std::string ReadFileData();
        std::wstring NormalizeFileData(const std::string &file_data);

        // Disallow copying
        ReadPdf(const ReadPdf &) = delete;
        ReadPdf &operator=(const ReadPdf &) = delete;
};

#endif // READPDF_H