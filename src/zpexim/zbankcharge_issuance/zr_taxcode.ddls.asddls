@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for tax code'
define root view entity ZR_TAXCODE
  as select from I_TaxCode      as a
    inner join   I_TaxCodeText  as b on a.TaxCode = b.TaxCode and a.TaxCalculationProcedure = b.TaxCalculationProcedure
    inner join   zdt_bnktaxcode as c on a.TaxCode = c.taxcode
{
  key a.TaxCode,
  key b.TaxCodeName

}
where
      a.TaxCalculationProcedure =  '0TXIN'
  and a.TaxType                 =  'V'
  and b.Language                =  'E'
  and a.TaxCodeIsInactive       <> 'X'
