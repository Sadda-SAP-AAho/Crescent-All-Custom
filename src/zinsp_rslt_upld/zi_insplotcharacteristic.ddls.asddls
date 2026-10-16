@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Insp. Lot Characteristics - Interface'
@VDM.viewType: #BASIC
define view entity ZI_InspLotCharacteristic
  as select from I_InspectionCharacteristic 
{
  key InspectionLot,
  key InspectionCharacteristic,
      InspPlanOperationInternalID,
      InspectionSpecificationText,
      InspSpecLowerLimit,
      InspSpecUpperLimit,
      InspectionSpecificationUnit,
      InspSpecIsQuantitative,
      SelectedCodeSet,

      case
        when InspSpecIsQuantitative = 'X'
          then concat(
                 concat( cast( cast( InspSpecLowerLimit as abap.dec( 23, 5 ) ) as abap.char( 30 ) ), '-' ),
                 cast( cast( InspSpecUpperLimit as abap.dec( 23, 5 ) ) as abap.char( 30 ) )
               )
        else SelectedCodeSet
      end as TargetValue
};
