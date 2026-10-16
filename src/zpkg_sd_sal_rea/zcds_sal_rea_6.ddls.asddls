@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Terms Days'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_6 
as select from ZCDS_SAL_REA_5 as a
inner join I_PaymentTermsConditions as b on  b.PaymentTerms = a.PaymentTerms 
                                         and b.PaymentTermsValidityMonthDay = a.PaymentTermsValidityMonthDay   
{
    a.PaymentTerms,
    b.CashDiscount1Days
}
