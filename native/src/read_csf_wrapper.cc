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

const wchar_t* get_birth_date(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_birth_date().c_str();
}

const wchar_t* get_city(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_city().c_str();
}

const wchar_t* get_colonia(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_colonia().c_str();
}

const wchar_t* get_curp(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_curp().c_str();
}

const wchar_t* get_economic_activities(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_economic_activities().c_str();
}

const wchar_t* get_house_number(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_house_number().c_str();
}

const wchar_t* get_name(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_name().c_str();
}

const wchar_t* get_regimes(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_regimes().c_str();
}

const wchar_t* get_rfc(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_rfc().c_str();
}

const wchar_t* get_state(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_state().c_str();
}

const wchar_t* get_street(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_street().c_str();
}

const wchar_t* get_zip_code(void* instance) {
    return static_cast<ReadCsf*>(instance)->get_zip_code().c_str();
}
