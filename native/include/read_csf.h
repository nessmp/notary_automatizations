#ifndef READCSF_H
#define READCSF_H

#include "read_pdf.h"

#include <string>

class ReadCsf : public ReadPdf {
    public:
        ReadCsf(const std::string &file_path);
        ~ReadCsf();

        void Execute() override;
        void PrintCsfData();

        std::wstring get_birth_date() const;
        std::wstring get_city() const;
        std::wstring get_colonia() const;
        std::wstring get_curp() const;
        std::wstring get_economic_activities() const;
        std::wstring get_house_number() const;
        std::wstring get_name() const;
        std::wstring get_regimes() const;
        std::wstring get_rfc() const;
        std::wstring get_state() const;
        std::wstring get_street() const;
        std::wstring get_zip_code() const;

    private:
        std::wstring FindBirthDate(const std::wstring &curp);
        std::wstring FindCity();
        std::wstring FindColonia();
        std::wstring FindCurp();
        std::wstring FindEconomicActivities();
        std::wstring FindHouseNumber();
        std::wstring FindName();
        std::wstring FindRegimes();
        std::wstring FindRfc();
        std::wstring FindState();
        std::wstring FindStreet();
        std::wstring FindZipCode();
        std::wstring GetData(
          std::wstring title, 
          std::wstring last_keyword_title,
          std::wstring substring = L"");
        std::wstring LowerString(const std::wstring &str);
        std::wstring NormalizeData(const std::wstring &data);
        std::wstring TrimTrailingSpaces(std::wstring wstr);

        std::wstring birth_date_;
        std::wstring city_;
        std::wstring colonia_;
        std::wstring curp_;
        std::wstring economic_activities_;
        std::wstring house_number_;
        std::wstring name_;
        std::wstring regimes_;
        std::wstring rfc_;
        std::wstring state_;
        std::wstring street_;
        std::wstring zip_code_;

        // TODO: Move all the constants somewhere else.
        const std::wstring kBetweenStreet_ = L" Entre Calle:";
        const std::wstring kCity_ = L"Nombre de la Localidad: ";
        const std::wstring kColonia_ = L"Nombre de la Colonia: "; 
        const std::wstring kCurp_ = L"CURP: ";
        const std::wstring kEndDate_ = L"Fecha Fin";
        const std::wstring kFirstLastName_  = L"Primer Apellido: ";
        const std::wstring kHouseNumber_ = L"Número Exterior: ";
        const std::wstring kInternalHouseNumber_ = L"Número Interior: ";
        const std::wstring kMunicipality_ = 
          L"Nombre del Municipio o Demarcación Territorial: ";
        const std::wstring kName_ = L"Nombre (s): ";
        const std::wstring kObligations_ = L"Obligaciones: ";
        const std::wstring kPostalCode_ = L"Código Postal: "; 
        const std::wstring kRegimes_ = L"Regímenes: ";
        const std::wstring kRfc_ = L"RFC: "; 
        const std::wstring kSecondLastName_ = L"Segundo Apellido: ";
        const std::wstring kStartOperationsDate_ = 
          L"Fecha inicio de operaciones: ";
        const std::wstring kState_ = L"Nombre de la Entidad Federativa: "; 
        const std::wstring kStreet_ = L"Nombre de Vialidad: "; 
        const std::wstring kTyeOfStreet_ = L"Tipo de Vialidad: ";

        // Disallow copying
        ReadCsf(const ReadCsf &) = delete;
        ReadCsf &operator=(const ReadCsf &) = delete;
};

#endif // READCSF_H