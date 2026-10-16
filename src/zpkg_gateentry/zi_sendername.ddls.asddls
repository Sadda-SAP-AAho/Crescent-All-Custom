@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sender Name F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_sendername
  as select from I_Supplier as a
{
  key a.Supplier,
  key a.SupplierName,
      a.SupplierAccountGroup
}
where
  a.SupplierAccountGroup = 'ZEMP'
