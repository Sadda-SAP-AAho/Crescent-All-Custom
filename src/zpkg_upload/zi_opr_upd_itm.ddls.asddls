@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Operation Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_OPR_UPD_ITM 
as select from zdt_upd_opr_itm
association to parent ZI_OPR_UPD_HDR as _head on $projection.Id = _head.id
{
    
   key id as Id,
   key item as Item,
   _head
}
