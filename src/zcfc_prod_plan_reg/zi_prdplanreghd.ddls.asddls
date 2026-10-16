@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Production Plan Reg-Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define root view entity ZI_PRDPLANREGHD
  as select from zdt_prdplanreghd
  composition [0..*] of ZI_PRDPLANREGIT as _Item
{
  key zdt_prdplanreghd.id         as Id,
      zdt_prdplanreghd.fisyear    as Fisyear,
      zdt_prdplanreghd.docnum     as Docnum,
      zdt_prdplanreghd.keyid      as Keyid,
      zdt_prdplanreghd.creon      as Creon,
      zdt_prdplanreghd.creby      as Creby,
      zdt_prdplanreghd.plantcode  as Plantcode,
      zdt_prdplanreghd.plantname  as Plantname,
      zdt_prdplanreghd.matgrpcode as Matgrpcode,
      zdt_prdplanreghd.matgrpname as Matgrpname,
      zdt_prdplanreghd.prodyear   as Prodyear,
      zdt_prdplanreghd.prodmonth  as Prodmonth,
      _Item
}
