@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View of Container Planning App'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_CONTPLNAPP
  as select from zdt_contplnapp
{
  key zdt_contplnapp.id          as ID,
      zdt_contplnapp.plantcode   as Plantcode,
      zdt_contplnapp.plantname   as Plantname,
      zdt_contplnapp.fdcode      as FDCode,
      zdt_contplnapp.fdname      as FDName,
      zdt_contplnapp.prtentfrmdt as PrtEntFrmDt,
      zdt_contplnapp.prtenttodt  as PrtEntToDt,
      zdt_contplnapp.vsslnmvyg   as VsslNmVyg,
      zdt_contplnapp.custcode    as CustCode,
      zdt_contplnapp.nocontplnnd as NoContPlnnd,
      zdt_contplnapp.rmrkfact    as RmrkFact,
      zdt_contplnapp.rmrklogst   as RmrkLogst

}
