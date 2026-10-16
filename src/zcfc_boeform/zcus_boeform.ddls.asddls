@ObjectModel.query.implementedBy: 'ABAP:ZCL_BOEFORM_IMPL'
@EndUserText.label: 'Custom Entity for BOE Form'
define custom entity ZCUS_BOEFORM
{
  key BillNo     : vbeln_vl;
      BillDate   : sydate;
      Boeddt     : sydate;
      Currency   : abap.char(3);
      NetAmt     : abap.dec( 19, 2 );
      amtintext  : abap.char(256);
      TOP        : abap.char(100);
      BankAddr   : abap.char(256);
      CustName   : abap.char(60);
      StreetName : abap.char(60);
      PostalCode : abap.char(8);
      CityName   : abap.char(20);
      Country    : abap.char(20);
      printflag1  : abap.char(1);
      printflag2  : abap.char(1);
}
