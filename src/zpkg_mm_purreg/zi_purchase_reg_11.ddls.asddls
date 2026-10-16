@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register - QC Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_11 
as select from I_InspectionLot as a
{
    key a.InspectionLot,
    key a.MaterialDocument,
    key a.MaterialDocumentItem,
    key a.MaterialDocumentYear
    
}
where a.MaterialDocument is not initial
