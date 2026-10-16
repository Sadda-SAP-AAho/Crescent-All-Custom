@EndUserText.label: 'Taxcode Input Register'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TaxcodeInputRegiste
  as select from zdt_inreg_tax
  association to parent ZI_TaxcodeInputRegiste_S as _TaxcodeInputRegiAll on $projection.SingletonID = _TaxcodeInputRegiAll.SingletonID
{
  key id          as Id,
      taxcode     as Taxcode,
      taxcodename as Taxcodename,
      @EndUserText.label: 'CGST%'
      cgst        as Cgst,
      @EndUserText.label: 'SGST%'
      sgst        as Sgst,
      @EndUserText.label: 'CGST%'
      igst        as Igst,      
      trnskey1    as Trnskey1,
      trnskey2    as Trnskey2,
      trnskey3    as Trnskey3,
      trnskey4    as Trnskey4,
      trnskey5    as Trnskey5,
      trnskey6    as Trnskey6,
      trnskey7    as Trnskey7,
      trnskey8    as Trnskey8,
      @Consumption.hidden: true
      1           as SingletonID,
      _TaxcodeInputRegiAll

}
