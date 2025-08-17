#include "../include/read_csf.h"

#include <algorithm>
#include <iostream>
#include <vector>

ReadCsf::ReadCsf(const std::string &file_path) : ReadPdf(file_path) {}

ReadCsf::~ReadCsf() {}

std::wstring ReadCsf::GetData(
  std::wstring keyword, 
  std::wstring last_keyword,
  std::wstring substring) {
    std::wstring data = L"";
    std::wstring str = substring.empty() ? file_data() : substring;

    std::size_t data_index = str.find(keyword);
    std::size_t last_keyword_index = str.find(last_keyword);
    if (data_index != std::string::npos && 
      last_keyword_index != std::string::npos) {
        data_index += keyword.length();
        data = str.substr(data_index, last_keyword_index - data_index);
    }

    return data;
}

std::wstring ReadCsf::FindBirthDate(const std::wstring &curp) {
    // Birth date in YYMMDD format
    std::wstring curp_birth_date = curp.substr(4, 6);

    std::wstring day = curp_birth_date.substr(4, 2);
    
    std::wstring month = curp_birth_date.substr(2, 2);
    if (month == L"01") {
        month = L"Enero";
    } else if (month == L"02") {
        month = L"Febrero";
    } else if (month == L"03") {
        month = L"Marzo";
    } else if (month == L"04") {
        month = L"Abril";
    } else if (month == L"05") {
        month = L"Mayo";
    } else if (month == L"06") {
        month = L"Junio";
    } else if (month == L"07") {
        month = L"Julio";
    } else if (month == L"08") {
        month = L"Agosto";
    } else if (month == L"09") {
        month = L"Septiembre";
    } else if (month == L"10") {
        month = L"Octubre";
    } else if (month == L"11") {
        month = L"Noviembre";
    } else if (month == L"12") {
        month = L"Diciembre";
    }

    std::wstring year = curp_birth_date.substr(0, 2);
    if (year[0] == '0' || year[0] == '1' || year[0] == '2') {
        year = L"20" + year;
    } else {
        year = L"19" + year;
    }

    return day + L" de " + month + L" de " + year;
}

std::wstring ReadCsf::get_birth_date() const { return birth_date_; }

std::wstring ReadCsf::FindCity() { return GetData(kCity_, kMunicipality_); }

std::wstring ReadCsf::get_city() const { return city_; }

std::wstring ReadCsf::FindColonia() { return GetData(kColonia_, kCity_); }

std::wstring ReadCsf::get_colonia() const { return colonia_; }

std::wstring ReadCsf::FindCurp() { return GetData(kCurp_, kName_); }

std::wstring ReadCsf::get_curp() const { return curp_; }

std::wstring ReadCsf::FindEconomicActivities() {
    std::wstring activities = GetData(kEndDate_, kRegimes_);

    // Normalize activities by removing numbers and dates and dividing them 
    // with ','.
    activities.erase(
      std::remove(activities.begin(), activities.end(), '/'), activities.end());
    return NormalizeData(activities);
}

std::wstring ReadCsf::get_economic_activities() const { 
    return economic_activities_;
}

std::wstring ReadCsf::FindHouseNumber() {
    return GetData(kHouseNumber_, kInternalHouseNumber_);
}

std::wstring ReadCsf::get_house_number() const { return house_number_; }

std::wstring ReadCsf::FindName() {
    return GetData(kName_, kFirstLastName_) + 
      GetData(kFirstLastName_, kSecondLastName_) + 
      GetData(kSecondLastName_, kStartOperationsDate_);
}

std::wstring ReadCsf::get_name() const { return name_; }

std::wstring ReadCsf::FindRegimes() {
    std::size_t regimes_index = file_data().find(kRegimes_);
    if (regimes_index != std::wstring::npos) {
        std::wstring substring = file_data().substr(regimes_index);
        std::wstring regimes = GetData(kEndDate_, kObligations_, substring);

        // Normalize regimes by removing numbers and dates and dividing them 
        // with ','.
        regimes.erase(std::remove(regimes.begin(), regimes.end(), '/'), 
          regimes.end());
        return NormalizeData(regimes);
    }

    return L"";
}

std::wstring ReadCsf::get_regimes() const { return regimes_; }

std::wstring ReadCsf::FindRfc() { return GetData(kRfc_, kCurp_); }

std::wstring ReadCsf::get_rfc() const { return rfc_; }

std::wstring ReadCsf::FindState() { return GetData(kState_, kBetweenStreet_); }

std::wstring ReadCsf::get_state() const { return state_; }

std::wstring ReadCsf::FindStreet() {
    return LowerString(GetData(kStreet_, kHouseNumber_));
}

std::wstring ReadCsf::get_street() const { return street_; }

std::wstring ReadCsf::FindZipCode() { 
    return GetData(kPostalCode_, kTyeOfStreet_); 
}

std::wstring ReadCsf::get_zip_code() const { return zip_code_; }


void ReadCsf::Execute() {
    ReadPdf::Execute();

    curp_ = TrimTrailingSpaces(FindCurp());
    birth_date_ = FindBirthDate(curp_);
    city_ = LowerString(TrimTrailingSpaces(FindCity()));
    colonia_ = LowerString(TrimTrailingSpaces(FindColonia()));
    economic_activities_ = FindEconomicActivities();
    house_number_ = TrimTrailingSpaces(FindHouseNumber());
    name_ = TrimTrailingSpaces(FindName());
    regimes_ = FindRegimes();
    rfc_ = TrimTrailingSpaces(FindRfc());
    state_ = LowerString(FindState());
    street_ = LowerString(TrimTrailingSpaces(FindStreet()));
    zip_code_ = TrimTrailingSpaces(FindZipCode());
}

std::wstring ReadCsf::NormalizeData(const std::wstring &data) {
    int activity_first_index = -1;
    int activity_last_index = -1;
    std::vector<std::wstring> data_vector = {};

    for (
      std::basic_string<wchar_t>::size_type  i = 0; i < data.length(); i++) {
        std::locale loc;
        if (activity_first_index < 0) {
            if (!std::isspace(data[i], loc) && !std::isdigit(data[i], loc)) {
                activity_first_index = i;
            }
        } else {
            if (std::isdigit(data[i], loc)) {
                activity_last_index = i - 1;
                data_vector.push_back(data.substr(
                  activity_first_index, 
                  activity_last_index - activity_first_index));
                activity_first_index = -1;
                activity_last_index = -1;
            }
        }
    }

    std::wstring result = L"";
    for (std::size_t  i = 0; i < data_vector.size(); i++) {
        result += data_vector[i];
        if (i != data_vector.size() -1) {
            result += L";";
        }
    }

    return result;
}

std::wstring ReadCsf::LowerString(const std::wstring &str) {
    std::locale loc;
    std::wstring result;
    bool newWord = true;

    for (char ch : str) {
        if (std::isspace(ch, loc)) {
            newWord = true;
            result += ch;
        } else {
            if (newWord) {
                result += std::toupper(ch, loc);
                newWord = false;
            } else {
                result += std::tolower(ch);
            }
        }
    }
    return result;
}

std::wstring ReadCsf::TrimTrailingSpaces(std::wstring wstr) {
    wstr.erase(std::find_if(wstr.rbegin(), wstr.rend(), [](wchar_t ch) {
        return !std::iswspace(ch);
    }).base(), wstr.end());

    return wstr;
}

void ReadCsf::PrintCsfData() {
    std::wcout << L"----------------------------------------" << std::endl;
    std::wcout << L"Datos del CSF:" << std::endl;
    std::wcout << L"Nombre: " << name_ << std::endl;
    std::wcout << L"RFC: " << rfc_ << std::endl;
    std::wcout << L"CURP: " << curp_ << std::endl;
    std::wcout << L"Fecha de nacimiento: " << birth_date_ << std::endl;
    std::wcout << L"Calle: " << street_ << std::endl;
    std::wcout << L"Numero de casa: " << house_number_ << std::endl;
    std::wcout << L"Colonia: " << colonia_ << std::endl;
    std::wcout << L"Ciudad: " << city_ << std::endl;
    std::wcout << L"Estado: " << state_ << std::endl;
    std::wcout << L"Código Postal: " << zip_code_ << std::endl;
    std::wcout << L"Actividades Económicas: " << 
      economic_activities_ << std::endl;
    std::wcout << L"Regímenes: " << regimes_ << std::endl;
    std::wcout << L"----------------------------------------" << std::endl;
}
