@ObjectModel.query.implementedBy: 'ABAP:ZCL_INV_IMPL'
@EndUserText.label: 'Header CDS for Print'

define custom entity ZZVVHEADER
{
  key InvoiceNo          : abap.char( 10 );
  key FiscalYear         : abap.numc( 4 );
      InvoiceReference   : abap.char( 16 );
      InvoiceDate        : abap.dats(8);
      InvoiceGSTIN       : abap.char( 18 );
      CompanyName        : abap.char(75);
      Address1           : abap.char(100);
      Address2           : abap.char(100);
      Currency           : abap.cuky( 5 );
      Customer           : abap.char( 10 );
      CustomerName       : abap.char( 80 );
      CustomerStreetName : abap.char( 35 );
      CustomerPostalCode : abap.char( 10 );
      CustomerCity       : abap.char(35);
      CustomerCountry    : abap.char( 3 );
      CustomerGSTIN      : abap.char(18);
      Bankdetails        : abap.char(200);
      BankName           : abap.char( 50 );
      Irn                : abap.char(64);
      QRCode             : abap.string( 999999 );
      _item              : association [1..*] to ZZVITEM on $projection.InvoiceNo = _item.InvoiceNo
                                                        and $projection.FiscalYear = _item.FiscalYear;

}
