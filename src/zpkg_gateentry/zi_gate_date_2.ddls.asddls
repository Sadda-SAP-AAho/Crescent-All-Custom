@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GATE_DATE_2
  as select from ZI_GATE_DATE_1
{
  key Gatepass,
      concat( erdat1,concat(erdat2, erdat3))                            as erdat,
      concat( gatepassdate1,concat(gatepassdate2, gatepassdate3))       as gatepassdate,
      concat( challandate1,concat(challandate2, challandate3))          as challandate,
      concat( gateentrydate1,concat(gateentrydate2, gateentrydate3))    as gateentrydate,
      concat( vehicleoutdate1,concat(vehicleoutdate2, vehicleoutdate3)) as vehicleoutdate,
      concat( lbbldate1,concat(lbbldate2, lbbldate3))                   as lbbldate

}
