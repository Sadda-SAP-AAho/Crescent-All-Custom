@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gateentry Date Modification'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GATE_DATE_1
  as select from zdt_ghead
{

  key gatepass                                         as Gatepass,
      concat( substring( erdat, 7, 2 ), '.' )          as erdat1,
      concat( substring( erdat, 5, 2 ), '.' )          as erdat2,
      substring( erdat, 1, 4 )                         as erdat3,
      concat( substring( gatepassdate, 7, 2 ), '.' )   as gatepassdate1,
      concat( substring( gatepassdate, 5, 2 ), '.' )   as gatepassdate2,
      substring( gatepassdate, 1, 4 )                  as gatepassdate3,
      concat( substring( challandate, 7, 2 ), '.' )    as challandate1,
      concat( substring( challandate, 5, 2 ), '.' )    as challandate2,
      substring( challandate, 1, 4 )                   as challandate3,
      concat( substring( gateentrydate, 7, 2 ), '.' )  as gateentrydate1,
      concat( substring( gateentrydate, 5, 2 ), '.' )  as gateentrydate2,
      substring( gateentrydate, 1, 4 )                 as gateentrydate3,
      concat( substring( vehicleoutdate, 7, 2 ), '.' ) as vehicleoutdate1,
      concat( substring( vehicleoutdate, 5, 2 ), '.' ) as vehicleoutdate2,
      substring( vehicleoutdate, 1, 4 )                as vehicleoutdate3,
      concat( substring( lbbldate, 7, 2 ), '.' )       as lbbldate1,
      concat( substring( lbbldate, 5, 2 ), '.' )       as lbbldate2,
      substring( lbbldate, 1, 4 )                      as lbbldate3


}
