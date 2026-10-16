@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function For Final PL Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_FINALPLITEM

returns
{
  key mandt                       : abap.clnt;
  key BillingDocument             : vbeln;
  key BillingDocumentItem         : posnr;
      priority                    : abap.numc(5);
      Material                    : matnr;
      BillingDocumentItemText     : arktx;
      BillingQuantityUnit         : vrkme;
      BillingQuantity             : fkimg;
      TransactionCurrency         : abap.cuky;
      ConsumptionTaxCtrlCodeText1 : abap.char(60);
      ConsumptionTaxCtrlCode      : abap.char(16);
      ConditionRateValue          : abap.dec(13,2);
      PurchaseOrderByCustomer     : bstkd;
      CustomerPurchaseOrderDate   : sydate;
      AdditionalMaterialGroup1    : abap.char(3);
      BillingDocumentDate         : sydate;
      UnderlyingPurchaseOrderItem : posex;
      PurchaseOrderByShipToParty  : abap.char(35);
      MaterialByCustomer          : abap.char(35);
      Wtunit                      : meins;
      Packqty                     : abap.quan(13,2);
      Packmattyp                  : zde_packmat_typ;
      Eachnetwt                   : abap.quan(13,2);
      Eachgrowt                   : abap.quan(13,2);
      Qty                         : abap.quan(13,2);
      Netwt                       : abap.quan(13,2);
      Growt                       : abap.quan(13,2);
      Mateachpkg                  : abap.quan(13,2);
      Meins                       : meins;
      Contno                      : abap.char(200);


}

implemented by method
  zcl_finalpl_item_print=>sort_data;