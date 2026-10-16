@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_37

  as select from I_CustomerReturnItem as a

{
  key a.CustomerReturn,
  key a.CustomerReturnItem,
      a.ReferenceSDDocument,
      a.ReferenceSDDocumentItem

}
