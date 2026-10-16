@EndUserText.label: 'Shipping Instruction Print'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZHSNV1'
define view ZCDS__HSNTBLFUNC
  as select from ZCDS_HSN
                 (
                 mandt : $session.client
                 )
{
  key BookingNo,  
      Delivery,
      Marks,
      ContainerNo,
      SealNo,
      FinalSeal,
      HeaderWeightUnit,
      @Semantics.quantity.unitOfMeasure : 'HeaderWeightUnit'
      HeaderNetWeight,
      CreationDate,
//      HSNCode,
//      HSNDescp,
      Address,
      Customername
}
