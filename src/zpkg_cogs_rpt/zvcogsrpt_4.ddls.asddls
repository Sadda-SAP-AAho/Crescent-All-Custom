@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_4

  as select from ZVCOGSRPT_3

{

  key    ReferenceSDDocument,
  key    ReferenceSDDocumentItem,
  key    case when BillingDocumentType = 'F8' then BillingDocument else '' end as GSTInvoiceNumber,
  key    case when BillingDocumentType = 'F2' then BillingDocument else '' end as CommercialInvoiceNumber,
         SoldToParty

}
