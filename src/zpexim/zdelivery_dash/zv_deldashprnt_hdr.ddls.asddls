@ObjectModel.query.implementedBy: 'ABAP:ZCL_DELDASHPRNT_IMPL'
@EndUserText.label: 'Delivery Dashboard Print'
define custom entity ZV_DELDASHPRNT_HDR

{
      //  key id :   sysuuid_x16 ;
  key DeliveryDocument          :  vbeln_vl;
      CreationDate              :  sydate;
      CreationTime              :  timn;
      gstin                     :  abap.char(20);
      name                      :  abap.char(70);
      caddress1                 :  abap.char(100);
      caddress2                 :  abap.char(100);
      caddress3                 :  abap.char(100);
      Precarby                  :  abap.char(30);
      Por                       :  abap.char(30);
      Vesselno                  :  abap.char(30);
      Contno                    :  abap.char(30);
      Coo                       :  abap.char(30);
      Cod                       :  abap.char(30);
      Pol                       :  abap.char(100);
      Pod                       :  abap.char(100);
      Findes                    :  abap.char(30);
      Descgoods                 :  abap.char(100);
      descgoods1                :  abap.char(100);
      IncoTermsClassification   :  abap.char(5);
      CustomerPaymentTermsName  :  abap.char(30);
      iec                       :  abap.char(15);
      plantaddr1                :  abap.char(50);
      plantaddr2                :  abap.char(50);
      customernamesh            :  abap.char(100);
      addresssh                 :  abap.char(300);
      customernamebp            :  abap.char(100);
      addressbp                 :  abap.char(300);
      amtintext                 :  abap.char(256);
      salesnoteref              :  abap.char(100);
      lutigst                   : zdm_exim_lut;
      scomdec                   : abap.char(200);
      femadec                   : abap.char(255);
      plant                     : abap.char(4);
      var3                      : abap.char(30);
      cusmar                    : abap.char(200);
      zcuspodate                : abap.char(200);
      _item           : association [1..*] to ZV_PROFORMA_ITMFINAL on  $projection.DeliveryDocument = _item.DeliveryDocument;
      _item1          : association [1..*] to ZCDS_TABLE2 on $projection.DeliveryDocument = _item1.DeliveryDocument;
      _item2          : association [1..*] to ZCDS_TABLE3 on $projection.DeliveryDocument = _item2.DeliveryDocument;
      _item3          : association [1..*] to ZCDS_TABLE4 on $projection.DeliveryDocument = _item3.DeliveryDocument;
      _item4          : association [1..*] to ZCDS_CONCATPO on $projection.DeliveryDocument = _item4.DeliveryDocument;
}
;
