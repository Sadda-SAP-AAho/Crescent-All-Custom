@AbapCatalog.sqlViewName: 'ZRBANKMAST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Bank Master'
@Metadata.ignorePropagatedAnnotations: true
define view ZR_BANKMAST
  as select distinct from zexim_bank_mast
{
  key    bukrs     as Bukrs,
  key    hbkid     as Hbkid,
  key    hktid     as Hktid,
  key    bankl     as Bankl,
  key    zifsccode as Zifsccode,
  key    zbank     as Zbank,
  key    zaddress  as Zaddress,
  key    zbankgl   as Zbankgl,
  key    zincgl    as Zincgl,
  key    zoutgl    as Zoutgl,
  key    zvendor   as Zvendor,
  key    zswift    as Zswift,
  key    zaccno    as Zaccno,
  key    zbranch   as Zbranch,
  key    zaddress1 as Zaddress1,
  key    zaddress2 as Zaddress2,
  key    zaddress3 as Zaddress3,
  key    zadcode   as Zadcode,
  key    zstate    as Zstate
}
where
      zland1 = 'IN'
  and hbkid  is not initial
