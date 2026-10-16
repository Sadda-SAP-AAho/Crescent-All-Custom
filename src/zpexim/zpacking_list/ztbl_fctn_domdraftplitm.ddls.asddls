@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function For DomesticDraft PL Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_DOMDRAFTPLITM

returns
{
  key mandt                       : abap.clnt;
  key DeliveryDocument            : vbeln_vl;
  key Revision                    : abap.numc(3);
  key DeliveryDocumentItem        : posnr_vl;
      Packqty                     : abap.quan(13,3);
      Priority                    : abap.numc(5);
      Matnr                       : abap.char(40);
      Maktx                       : abap.char(40);
      Mateachpkg                  : abap.quan(13,3);
      Qty                         : abap.quan(13,3);
      UnderlyingPurchaseOrderItem : abap.char(6);
      Wtunit                      : meins;
      Eachnetwt                   : abap.quan(13,3);
      Netwt                       : abap.quan(13,3);
      Growt                       : abap.quan(13,3);
      Eachgrowt                   : abap.quan(13,3);
      Meins                       : meins;
}

implemented by method
  zcl_domdraftpl_item_print=>sort_data;