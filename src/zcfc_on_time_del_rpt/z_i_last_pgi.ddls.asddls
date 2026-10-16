@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last PGI Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_LAST_PGI 
  as select distinct from ZI_PGI_DATA
{
   key SalesOrder,
   key SalesOrderItem,
       PGINo,
       PGIDate
   
}
