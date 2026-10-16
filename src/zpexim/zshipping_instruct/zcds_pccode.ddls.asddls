@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for plant consumption code'
define root view entity ZCDS_PCCODE
  as select distinct from I_ProductPlantBasic       as a
    inner join            I_AE_CnsmpnTaxCtrlCodeTxt as b on  a.ConsumptionTaxCtrlCode = b.ConsumptionTaxCtrlCode
                                                         and b.CountryCode            = 'IN'
                                                         and b.Language               = 'E'
                                                         and b.ConsumptionTaxCtrlCode is not initial
{
  key a.Product,
  key a.ConsumptionTaxCtrlCode,
      a.Plant,
      b.ConsumptionTaxCtrlCodeText1


}
group by
  a.Product,
  a.ConsumptionTaxCtrlCode,
  a.Plant,
  b.ConsumptionTaxCtrlCodeText1
