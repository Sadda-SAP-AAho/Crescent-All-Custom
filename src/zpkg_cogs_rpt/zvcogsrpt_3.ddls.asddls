@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_3

  as select from I_BillingDocument     as a

    inner join   I_BillingDocumentItem as b on b.BillingDocument = a.BillingDocument    

{

  key b.BillingDocument,
  key b.BillingDocumentItem,
      b.ReferenceSDDocument,
      b.ReferenceSDDocumentItem,
      a.BillingDocumentType,
      a.SoldToParty

}

where
     a.BillingDocumentType = 'F2'
  or a.BillingDocumentType = 'F8'
