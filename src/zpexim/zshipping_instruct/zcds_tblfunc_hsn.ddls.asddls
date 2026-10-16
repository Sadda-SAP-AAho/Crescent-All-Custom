@EndUserText.label: 'Shipping Instruction Print'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZHSNV2'
define view ZCDS_TBLFUNC_HSN
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
      Descgoods,
      Descgoods1,
      FinalSeal,
      HeaderWeightUnit,
      @Semantics.quantity.unitOfMeasure : 'HeaderWeightUnit'
      HeaderNetWeight,
      CreationDate,
      HSNCode,
//      HSNDescp,
      Address,
      Customername,
      Customer,
      Counconsignee,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      Growt,
      Packqty,
//      Packmattyp,
      Wtunit,
      Meins,
      ShippingBill,
      ShippingBillDate,
       BillingDocument,
         BillingDocumentDate  
}
