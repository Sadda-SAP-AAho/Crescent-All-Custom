@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Table Function for ShipIns HSNCODE'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZCDS_HSN with parameters
    @Environment.systemField: #CLIENT
    mandt : abap.clnt
returns 
{
     key mandt              : abap.clnt;
     key BookingNo          : abap.char(100);
         Delivery           : vbeln_vl;
         Marks              : abap.char(100);
         ContainerNo        : abap.char(200);
         SealNo             : abap.char(40);
         Descgoods          : abap.char(500);
         Descgoods1         : abap.char(500);
         FinalSeal          : abap.char(20);
         HeaderWeightUnit   : meins;
         HeaderNetWeight    : abap.quan(15,3);
         CreationDate       : sydate;
         HSNCode            : abap.char(60);
//         HSNDescp           : abap.char(60);
         Address            : abap.char(200);
         Customername       : abap.char(100);
         Customer           : abap.char(20);
         Counconsignee      : abap.char(30);
         Growt              : abap.quan(13,3);
         Packqty            : abap.char(100);
//         Packmattyp         : abap.char(40);
         Wtunit             : meins;
         Meins              : meins;  
         ShippingBill       : abap.char(20);
         ShippingBillDate   : sydate; 
         BillingDocument    : vbeln;
         BillingDocumentDate : sydate;      
}
implemented by method zcl_tbfunc_zcds_hsn=>get_data;
