#include "../include/read_csf.h"
#include "../include/read_csf_wrapper.h"

void* create(const char* file_path) {
    // TODO(ness). The file path should be adjusted based on upload.
    auto csf =  new ReadCsf(file_path);
    csf->Execute();
    return static_cast<void*>(csf);
}

void destroy(void* instance) {
    delete static_cast<ReadCsf*>(instance);
}

const wchar_t* get_name(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_name().c_str();
}
