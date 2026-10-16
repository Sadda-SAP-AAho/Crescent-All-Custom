@ObjectModel.query.implementedBy: 'ABAP:ZCL_SHIPINS_IMPL'
@EndUserText.label: 'Shipping Instruction Print'
define custom entity ZCUS_SHIPPINGINSTRUC
{
key Bookingno       :   abap.char(100);
    name            :   abap.char(75);
    caddress1       :   abap.char(100);
    caddress2       :   abap.char(100);
    Shipmenttype    :   abap.char(75);
    Shippingtype    :   abap.char(75);
    address         :   abap.char(300);
    customername    :   abap.char(100);
    Precarby        :   abap.char(30);
    Pol             :   abap.char(100);
    Por             :   abap.char(60);
    Pod             :   abap.char(100);
    Placedel        :   abap.char(100);
    Loadingpier     :   abap.char(100);
    Expcarrvoyage   :   abap.char(75);
    Notifyp1name    :   abap.char(150);
    Notifyp1add1    :   abap.char(150);
    Notifyp1add2    :   abap.char(150);
    Notifyp2name    :   abap.char(150);
    Notifyp2add1    :   abap.char(150);
    Notifyp2add2    :   abap.char(150);
    Notifyp3name    :   abap.char(150);
    Notifyp3add1    :   abap.char(150);
    Notifyp3add2    :   abap.char(150);
    Deliveradd      :   abap.char(150);
    Deliveradd1     :   abap.char(150);
    Deliveradd2     :   abap.char(150);
   _item           : association [1..*] to ZCDS_TBLFUNC_HSN on  $projection.Bookingno = _item.BookingNo;
   _item1           : association [1..*] to ZCDS_CONTSIZE on  $projection.Bookingno = _item1.Bookingno;
}
