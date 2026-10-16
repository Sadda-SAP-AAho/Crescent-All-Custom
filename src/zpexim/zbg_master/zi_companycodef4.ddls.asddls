@AbapCatalog.sqlViewName: 'ZCOMF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'companycode f4'
define view zi_companycodef4 as select from I_CompanyCode
{
    key CompanyCode,
    CompanyCodeName,
    CityName,
    Country,
    Currency,
    Language,
    ChartOfAccounts,
    FiscalYearVariant,
    Company,
    CreditControlArea,
    CountryChartOfAccounts,
    FinancialManagementArea,
    AddressID,
    TaxableEntity,
    VATRegistration,
    ExtendedWhldgTaxIsActive,
    ControllingArea,
    FieldStatusVariant,
    NonTaxableTransactionTaxCode,
    DocDateIsUsedForTaxDetn,
    TaxRptgDateIsActive,
    CashDiscountBaseAmtIsNetAmt,
    /* Associations */
    _Address,
    _ChartOfAccounts,
    _ChartOfAccountsText,
    _CompanyCodeHierNode,
    _ControllingArea,
    _ControllingAreaText,
    _Country,
    _CountryChartOfAccounts,
    _CountryChartOfAccountsText,
    _CreditControlArea,
    _CreditControlAreaText,
    _Currency,
    _FieldStatusVariant,
    _FiscalYearVariant,
    _GlobalCompany,
    _Language,
    _OrgAddressDefaultRprstn
}
