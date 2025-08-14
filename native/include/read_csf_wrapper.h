#pragma once

#ifdef __cplusplus
extern "C" {
#endif

    void* create(const char* file_path);
    void destroy(void* instance);

    const wchar_t* get_birth_date(void* instance);
    const wchar_t* get_city(void* instance);
    const wchar_t* get_colonia(void* instance);
    const wchar_t* get_curp(void* instance);
    const wchar_t* get_economic_activities(void* instance);
    const wchar_t* get_house_number(void* instance);
    const wchar_t* get_name(void* instance);
    const wchar_t* get_regimes(void* instance);
    const wchar_t* get_rfc(void* instance);
    const wchar_t* get_state(void* instance);
    const wchar_t* get_street(void* instance);
    const wchar_t* get_zip_code(void* instance);

#ifdef __cplusplus
}
#endif
