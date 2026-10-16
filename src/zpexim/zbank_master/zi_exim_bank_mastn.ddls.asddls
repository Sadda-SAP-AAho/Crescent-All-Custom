@EndUserText.label: 'EXIM Bank Master Interace View New'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_EXIM_BANK_MASTN
  as select from zexim_bank_mastn
{
  key bukrs     as Bukrs,
  key zland1    as Zland1,
  key hbkid     as hbkid,
  key bankl     as bankl,
  key zifsccode as ZifscCode,
      zswift    as Zswift,
      zbankgl   as zbankgl,
      zincgl    as zincgl,
      zoutgl    as zoutgl,
      zvendor   as zvendor,
      zbank     as Zbank,
      zaccno    as ZaccNo,
      zbranch   as Zbranch,
      zaddress  as Zaddress,
      zaddress1 as Zaddress1,
      zaddress2 as Zaddress2,
      zaddress3 as Zaddress3,
      zadcode   as ZadCode,
      zstate    as Zstate,
      locallastchangedat
}
