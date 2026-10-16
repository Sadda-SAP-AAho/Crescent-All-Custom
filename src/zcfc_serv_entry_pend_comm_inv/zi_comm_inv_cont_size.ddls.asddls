@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Container Size against Commercial Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_COMM_INV_CONT_SIZE
  as select distinct from I_BillingDocument     as a
    inner join            I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
    inner join            ZI_DELDASH_HDR        as c on b.ReferenceSDDocument = c.Delivery
{
  key a.BillingDocument,
      max(c.Consizen) as contsize
}

group by
  a.BillingDocument
