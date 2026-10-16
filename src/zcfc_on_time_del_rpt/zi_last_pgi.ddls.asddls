@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last PGI Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_LAST_PGI
  as select distinct from ZTBL_FCTN_LAST_PGI
{
  key SalesOrder,
  key SalesOrderItem,
      PGINo,
      PGIDate
}
