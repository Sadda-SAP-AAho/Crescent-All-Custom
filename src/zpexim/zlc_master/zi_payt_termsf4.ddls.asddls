@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Payment Terms'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_payt_termsf4 
as select from I_PaymentTerms as p
left outer join I_PaymentTermsText as t on p.PaymentTerms = t.PaymentTerms
{
    key t.Language,
    key p.PaymentTerms,
    t.PaymentTermsDescription
    
}
