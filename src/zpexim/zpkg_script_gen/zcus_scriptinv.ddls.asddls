@ObjectModel.query.implementedBy: 'ABAP:ZCL_SCPTINV_IMPL'
@EndUserText.label: 'Custom Entity for Script Invoice'
define custom entity ZCUS_SCRIPTINV
{
      key scriptsalesno         : abap.char(20);
      accdocno                  : abap.char(10);
      scriptsalesdate           : sydate;
      CustomerName              : abap.char(80);
      StreetName                : abap.char(35);
      CityName                  : abap.char(35);
      Country                   : land1_gp;
      PostalCode                : pstlz;
      bnkname                   : abap.char(200);
      bnkstreet                 : abap.char(200);
      bnkcity                   : abap.char(30);
      bnkaccno                  : abap.char(30);
      bnkswiftcode              : abap.char(50);
      caddress1                 : abap.char(100);
      caddress2                 : abap.char(100);
      caddress3                 : abap.char(100);
      name                      : abap.char(75);
      gstin                     : abap.char(50);
      cmobile                   : abap.char(20);
      var6                      : abap.char(100);
      TaxNumber3                : stcd3;
      cemail                    : abap.char(75);
      amtintext                 : abap.char(256);
      cuspanno                  : abap.char(10);
      _item                       : association [1..*] to ZCDS_SCRIPTINV_ITM on  $projection.scriptsalesno = _item.scriptsalesno;
}
