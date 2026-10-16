@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Country Origin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Cntry_Orgf4 
as select from I_Country
{
    key Country,
    CountryThreeLetterISOCode,
    CountryThreeDigitISOCode,
    CountryISOCode,
    IsEuropeanUnionMember,
    BankAndBankInternalIDCheckRule,
    BankInternalIDLength,
    BankInternalIDCheckRule,
    BankNumberLength,
    BankCheckRule,
    BankAccountLength,
    BankPostalCheckRule,
    BankDataCheckIsCountrySpecific,
    CountryCurrency,
    IndexBasedCurrency,
    HardCurrency,
    TaxCalculationProcedure,
    CountryAlternativeCode
}
