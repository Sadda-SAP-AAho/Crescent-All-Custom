@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Terms Days'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_5 
as select from I_PaymentTermsConditions
{
    PaymentTerms,
    max( PaymentTermsValidityMonthDay ) as PaymentTermsValidityMonthDay
    
}
group by
PaymentTerms
