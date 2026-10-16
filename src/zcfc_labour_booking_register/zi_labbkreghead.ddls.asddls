@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Labour Booking Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_LABBKREGHEAD
  as select from zdt_labbkreghead
  composition [0..*] of ZI_LABBKREGITEM as _Item
{
  key zdt_labbkreghead.id                                             as Id,
      zdt_labbkreghead.fisyear                                        as Fisyear,
      zdt_labbkreghead.keyid                                          as Keyid,
      zdt_labbkreghead.docnum                                         as Docnum,
      zdt_labbkreghead.newkeyid                                       as NewKeyid,
      zdt_labbkreghead.newdocnum                                      as NewDocnum,
      zdt_labbkreghead.creon                                          as Creon,
      zdt_labbkreghead.creby                                          as Creby,
      zdt_labbkreghead.rptdate                                        as Rptdate,
      zdt_labbkreghead.plantcode                                      as Plantcode,
      zdt_labbkreghead.plantname                                      as Plantname,
      zdt_labbkreghead.costcode                                       as Costcode,
      zdt_labbkreghead.costname                                       as Costname,
      zdt_labbkreghead.contcode                                       as Contcode,
      zdt_labbkreghead.contname                                       as Contname,
      zdt_labbkreghead.oprcode                                        as Oprcode,
      zdt_labbkreghead.oprname                                        as Oprname,
      _Item
}
