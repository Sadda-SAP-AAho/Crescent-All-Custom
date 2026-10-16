@EndUserText.label: 'Tax GST Code with Percentage'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TaxGstCodeWithPerce
  as select from zdt_bnktaxcode
  association to parent ZI_TaxGstCodeWithPerce_S as _TaxGstCodeWithPeAll on $projection.SingletonID = _TaxGstCodeWithPeAll.SingletonID
{
  key taxcode     as Taxcode,
  key taxcodename as Taxcodename,
      @EndUserText.label: 'CGST%'
      cgst        as Cgst,
      @EndUserText.label: 'SGST%'
      sgst        as Sgst,
      @EndUserText.label: 'IGST%'
      igst        as Igst,
      @Consumption.hidden: true
      1           as SingletonID,
      _TaxGstCodeWithPeAll

}
