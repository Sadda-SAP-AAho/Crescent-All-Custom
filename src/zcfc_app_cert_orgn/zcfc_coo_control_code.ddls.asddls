@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for COO Control Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCFC_COO_Control_Code as select from I_BillingDocumentItem as _item
left outer join I_ProductPlantBasic as _prd on _item.Product = _prd.Product and _item.Plant = _prd.Plant
{    
     _item.BillingDocument,
    _prd.ConsumptionTaxCtrlCode
    
    
}where _item.BillingDocumentItem = '000010';  
