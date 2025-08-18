#include "../include/read_validity.h"
#include "../include/read_validity_wrapper.h"

void* create(const char* file_path) {
    // TODO(ness). The file path should be adjusted based on upload.
    auto csf =  new ReadValidity(file_path);
    csf->Execute();
    return static_cast<void*>(csf);
}

void destroy(void* instance) {
    delete static_cast<ReadValidity*>(instance);
}

const wchar_t* get_cic(void* instance) {
    return static_cast<ReadValidity*>(instance)->get_cic().c_str();
}

const wchar_t* get_ocr(void* instance) {
    return static_cast<ReadValidity*>(instance)->get_ocr().c_str();
}
