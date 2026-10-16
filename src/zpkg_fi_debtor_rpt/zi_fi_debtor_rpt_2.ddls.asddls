@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_2
  as select distinct from I_BillingDocumentItem as a
    left outer join       ZI_DELDASH_HDR        as f on  f.Delivery =  a.ReferenceSDDocument
                                                     and f.Canind   <> 'X'
{
  a.BillingDocument,
//  a.ReferenceSDDocument,
  f.Salesnoteref
}
where
  a.ReferenceSDDocumentCategory = 'J'
group by
  a.BillingDocument,
//  a.ReferenceSDDocument,
  f.Salesnoteref
