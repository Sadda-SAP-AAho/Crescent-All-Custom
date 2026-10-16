@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register - Workflow Date PO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZI_PURCHASE_REG_3 
as select from I_WorkflowStatusOverview as a
{
    key cast( a.SAPBusinessObjectNodeKey1 as abap.char(10)) as SAPBusinessObjectNodeKey1,
    max( cast( left( cast( a.WrkflwTskCompletionUTCDateTime as abap.char(30) ),8 ) as abap.dats ) ) as WrkflwTskCompletionUTCDateTime
    
}
where a.SAPObjectNodeRepresentation = 'PurchaseOrder' and
      a.WrkflwTskCompletionUTCDateTime is not initial
group by
a.SAPBusinessObjectNodeKey1
