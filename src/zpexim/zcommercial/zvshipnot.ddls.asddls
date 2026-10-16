@ObjectModel.query.implementedBy: 'ABAP:ZCL_SHIPNOTIFICATION_IMPL'
@EndUserText.label: 'View for shipping notification print'
define custom entity ZVSHIPNOT
{
  key id              : sysuuid_x16;
  key commid          : vbeln;
      bankrefno       : abap.char(20);
      ladingno        : abap.char(60);
      ladingdt        : sydate;
      billcloseflag   : abap.char(10);
      fundplanremark  : abap.char(100);
      isfsenddt       : sydate;
      lcbankadd1      : abap.char(100);
      lcbankadd2      : abap.char(100);
      boeddt          : sydate;
      docpresentbnkdt : sydate;
      swiftdt         : sydate;
      scrollno        : abap.char(100);
      vesselsaildt    : sydate;
      initmationdt    : sydate;
      paymentprocess  : abap.char(30);
      scripno         : abap.char(100);
      shbillrecddt    : sydate;
      correctblsendon : sydate;
      draftblcnfdt    : sydate;
      blrcvdt         : sydate;
      docsentcustdt   : sydate;
      atadate         : sydate;
      drftblrcvdt     : sydate;
      rotationno      : abap.char(40);
      tpno            : abap.char(40);
      tpdate          : sydate;
      leodate         : sydate;
      ebrcno          : abap.char(40);
      ebrcrcvdt       : sydate;
      waers           : abap.cuky;
      @Semantics.amount.currencyCode : 'waers'
      ebrcvalfc       : abap.curr(15,2);
      awbno           : abap.char(40);
      rcvconsignbnkdt : sydate;
      planingweek     : abap.char(40);
      planingmonth    : sydate;
      custrqstdt      : sydate;
      createdat       : sydate;
      tprint          : abap.char(1);
      customername    : abap.char(150);
      gstinvno        : abap.char(20);
      invdate         : sydate;
      sono            : abap.char(20);
      salesnoteno     : abap.char(20);
      itemcode        : abap.char(20);
      itemname        : abap.char(150);
      indexno         : abap.char(20);
      polineno        : abap.char(50);
      pono            : abap.char(20);
      podate          : sydate;
      uom             : meins;
      @Semantics.quantity.unitOfMeasure : 'uom'
      quantity        : menge_d;
      @Semantics.quantity.unitOfMeasure : 'uom'
      sumquantity     : menge_d;
      stuffingdate    : sydate;
      containerno     : abap.char(20);
      shippingline    : abap.char(75);
      companyname     : abap.char(150);
      comadd1         : abap.char(150);
      comadd2         : abap.char(150);
      creationdate    : sydate;
      creationtime    : abap.char(15);
}
