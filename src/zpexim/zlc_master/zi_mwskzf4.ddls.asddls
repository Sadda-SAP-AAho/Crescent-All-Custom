@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Tax Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_mwskzF4 
as select from I_TaxCode as t
{
    key TaxCalculationProcedure,
        key TaxCode,
        TaxType,
        TargetTaxCode,
        EUTaxClassification,
        IsSalesTaxes,
        TaxCategory,
        UnitedStatesTaxCategory
    
}
