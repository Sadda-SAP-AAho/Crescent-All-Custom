@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Inspectection Decision'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INSDEC_GRPO 
as select from I_InspectionLot            as a
inner join I_InspLotUsageDecision         as b on b.InspectionLot = a.InspectionLot
{
    a.MaterialDocument,
    a.MaterialDocumentItem,
    a.MaterialDocumentYear,
    case when b.InspectionLotUsageDecisionCode = 'ACP' then cast( 'Accepted' as abap.char(25) )
         when b.InspectionLotUsageDecisionCode = 'ACP' then cast( 'Accepted with Deviation' as abap.char(25) )
         when b.InspectionLotUsageDecisionCode = 'ACP' then cast( 'Rejected' as abap.char(25) )
         else cast( '' as abap.char(25) ) end as decision
}
group by
a.MaterialDocument,
a.MaterialDocumentItem,
a.MaterialDocumentYear,
b.InspectionLotUsageDecisionCode
