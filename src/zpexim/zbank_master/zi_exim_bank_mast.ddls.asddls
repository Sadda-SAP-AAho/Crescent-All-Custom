/*@AbapCatalog.sqlViewName: ''
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED*/
@EndUserText.label: 'Interface View of Bank Master'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_EXIM_BANK_MAST
  as select distinct from zexim_bank_mast
{
  key    internaid          as Internaid,
  key    bukrs              as Bukrs,
  key    banktype           as banktype,
         zland1             as Zland1,
         hbkid              as hbkid,
         hktid              as hktid,
         bankl              as bankl,
         zifsccode          as Zifsccode,
         zaccno             as Zaccno,
         zbank              as Zbank,
         zaddress           as Zaddress,
         zswift             as Zswift,
         zbankgl            as zbankgl,
         zincgl             as zincgl,
         zoutgl             as zoutgl,
         zvendor            as zvendor,
         zbranch            as Zbranch,
         zaddress1          as Zaddress1,
         zaddress2          as Zaddress2,
         zaddress3          as Zaddress3,
         zadcode            as Zadcode,
         zstate             as Zstate,
         locallastchangedat as Locallastchangedat
}
