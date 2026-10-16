@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for tax code'
define root view entity ZR_TAXCODE_GST
  as select distinct from I_TaxCode     as a
    inner join            I_TaxCodeText as b on a.TaxCode = b.TaxCode
{
  key a.TaxCode     as TaxCode,
  key b.TaxCodeName as TaxCodeName

}
where
      a.TaxCalculationProcedure =  '0TXIN'
  and a.TaxType                 =  'V'
  and b.Language                =  'E'
  and a.TaxCodeIsInactive       <> 'X'
