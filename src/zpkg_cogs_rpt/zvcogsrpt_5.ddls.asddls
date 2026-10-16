@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_5

  as select from ZVCOGSRPT_4
{
  key ReferenceSDDocument,
  key ReferenceSDDocumentItem,
      SoldToParty,
      max( GSTInvoiceNumber )        as GSTInvoiceNumber,
      max( CommercialInvoiceNumber ) as CommercialInvoiceNumber
}

group by
  ReferenceSDDocument,
  ReferenceSDDocumentItem,
  SoldToParty
