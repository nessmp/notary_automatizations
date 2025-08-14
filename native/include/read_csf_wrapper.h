#pragma once

#ifdef __cplusplus
extern "C" {
#endif

    void* create(const char* file_path);
    void destroy(void* instance);

    const wchar_t* get_name(void* instance);

#ifdef __cplusplus
}
#endif
