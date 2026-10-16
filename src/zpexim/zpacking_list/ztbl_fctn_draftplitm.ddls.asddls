@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function For Draft PL Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_DRAFTPLITM

returns
{
  key mandt                       : abap.clnt;
  key DeliveryDocument            : vbeln_vl;
  key Revision                    : abap.numc(3);
  key DeliveryDocumentItem        : posnr_vl;
      Packqty                     : abap.quan(13,3);
      Packmattyp                  : zde_packmat_typ;
      Priority                    : abap.numc(5);
      Wtunit                      : meins;
      ConsumptionTaxCtrlCode      : abap.char(20);
      ConsumptionTaxCtrlCodeText1 : text60;
      Eachnetwt                   : abap.quan(13,3);
      Qty                         : abap.quan(13,3);
      Matnr                       : abap.char(40);
      Meins                       : meins;
      UOM                         : mseh3;
      Netwt                       : abap.quan(13,3);
      Growt                       : abap.quan(13,3);
      Eachgrowt                   : abap.quan(13,3);
      PurchaseOrderByCustomer     : bstkd;
      PURCHASEORDERITEM           : posex;
      MaterialByCustomer          : abap.char(35);
      Matlngtxt                   : abap.char(100);
}

implemented by method
  zcl_draftpl_item_print=>sort_data;