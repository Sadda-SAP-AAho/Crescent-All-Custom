@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Result Record'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_INSPRSLTRCD
  as select distinct from I_InspLotSerialNumber   as a
    left outer join       I_InspectionResultValue as b on  a.InspectionLot = b.InspectionLot
                                                       and a.SerialNumber  = b.InspectionResultItem
{
  key a.InspectionLot,
  key a.SerialNumber                                                               as SerialNumber,
      ( case when b.InspectionResultItem is not initial then 'Yes' else 'No' end ) as ResultRecord

}
