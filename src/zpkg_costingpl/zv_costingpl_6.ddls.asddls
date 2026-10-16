@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_6

  as select from I_BillingDocumentItem

{

  key BillingDocument,
  key BillingDocumentItem,

      cast( ItemNetWeight as abap.dec( 15,3 ) ) as ItemNetWeight

}
