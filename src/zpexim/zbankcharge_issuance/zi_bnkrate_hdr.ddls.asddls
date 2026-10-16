@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Bank Rate Header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_BNKRATE_HDR
  as select from zdt_bnkrate_hdr
  composition [0..*] of ZI_BNKRATEEXP as _item
  composition [0..*] of ZI_BNKRATEIMP as _item1
  composition [0..*] of ZI_BNKRATEBG as _item2
{
key zdt_bnkrate_hdr.id as Id,
zdt_bnkrate_hdr.bankname as Bankname,
zdt_bnkrate_hdr.waers as Waers,
zdt_bnkrate_hdr.bankkey as Bankkey,
zdt_bnkrate_hdr.housebnkid as Housebnkid,
zdt_bnkrate_hdr.accountid as Accountid,
      _item,
      _item1,
      _item2
}
