@EndUserText.label: 'Import LC Bank Master'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_EXIM_LCIM_BNKMS

  as select from zexim_lcim_bnk1 as a

  //      left outer join ZR_BANK_LIMIT   as c on  c.Bukrs = a.bukrs
  //                                           and c.Hbkid = a.hbkid
  //                                           and c.Hktid = a.hktid

  association to zexim_bank_mast as _b on  $projection.Bukrs     = _b.bukrs
                                       and $projection.Zland1    = _b.zland1
                                       and $projection.Zswift    = _b.zswift
                                       and $projection.Zifsccode = _b.zifsccode
                                       and $projection.Zaccno    = _b.zaccno


{
  key                      a.internaid           as Internaid,
  key                      a.bukrs               as Bukrs,
  key                      a.bankl               as Bankl,
  key                      a.hbkid               as Hbkid,
  key                      a.hktid               as Hktid,
  key                      a.gjahr               as Gjahr,
  key                      a.zswift              as Zswift,
  key                      a.zaccno              as Zaccno,
                           a.zland1              as Zland1,
                           a.zifsccode           as Zifsccode,
                           a.zbank               as Zbank,
                           a.zbranch             as Zbranch,
                           a.zaddress            as Zaddress,
                           a.zaddress1           as Zaddress1,
                           a.zaddress2           as Zaddress2,
                           a.zaddress3           as Zaddress3,
                           a.zadcode             as Zadcode,
                           a.zstate              as Zstate,

                           a.commissionint       as Commissionint,
                           a.discountinginterest as Discountinginterest,
                           a.waers               as Waers,
                           a.bclimit             as Bclimit,
                           a.bccleanutilised     as Bccleanutilised,
                           a.bccleanavailable    as Bccleanavailable,
                           a.bglimit             as Bglimit,
                           a.bgcleanutilised     as Bgutilised,
                           //c.Bgutilised             as Bgutilised,
                           a.bgcleanavailable    as Bgavailable,
                           //a.bglimit - c.Bgutilised as Bgavailable,
                           a.bgpledgelimit       as Bgpledgelimit,
                           a.lclimit             as Lclimit,
                           a.lccleanutilised     as Lcutilised,
                           a.lccleanavailable    as lcavailable,
                           a.lcpledgelimit       as Lcpledgelimit,
                           a.pledgelimit         as Pledgelimit,
                           a.totalnonfundbased   as TotalnonfundBased,
                           a.fundbasedlimit      as Fundbasedlimit,
                           a.totallimit          as Totallimit,
                           a.interchangeability  as interchangeability,
                           a.cashc               as Cashc,
                           a.fcnr                as Fcnr,
                           a.wcdc                as Wcdc,
                           a.packcredit          as Packcredit,
                           a.cashcutilised       as cashcutilised,
                           a.fcnrutilised        as fcnrutilised,
                           a.wcdcutilised        as wcdcutilised,
                           a.packcreditutilised  as packcreditutilised,
                           a.lifnr               as Lifnr,
                           a.icgl                as Icgl,
                           a.oggl                as Oggl,
                           a.ref,
                           a.locallastchangedat  as Locallastchangedat,
                           _b
}
/* as select from    zexim_bank_mast  as a
   left outer join zexim_lcim_bnkms as b on  b.bukrs     = a.bukrs
                                         and b.zswift     = a.zswift
                                         and b.zifsccode = a.zifsccode
{

 key a.internaid as Internaid,
 key a.bukrs as Bukrs,
 key a.zland1 as Zland1,
 key a.zifsccode as Zifsccode,
 key  a.zaccno as Zaccno,
 a.zswift as Zswift,
 a.zbank as Zbank,
 a.zbranch as Zbranch,
 a.zaddress as Zaddress,
 a.zaddress1 as Zaddress1,
 a.zaddress2 as Zaddress2,
 a.zaddress3 as Zaddress3,
 a.zadcode as Zadcode,
 a.zstate as Zstate,
 b.bankl as Bankl,
 b.hbkid as Hbkid,
 b.hktid as Hktid,
 b.gjahr as Gjahr,
 b.commissionint as Commissionint,
 b.discountinginterest as Discountinginterest,
 b.waers as Waers,
 b.bclimit as Bclimit,
 b.bglimit as Bglimit,
 b.bgpledgelimit as Bgpledgelimit,
 b.lclimit as Lclimit,
 b.lcpledgelimit as Lcpledgelimit,
 b.pledgelimit as Pledgelimit,
 b.totalnonfund_based as TotalnonfundBased,
 b.fundbasedlimit as Fundbasedlimit,
 b.totallimit as Totallimit,
 b.cashc as Cashc,
 b.fcnr as Fcnr,
 b.wcdc as Wcdc,
 b.packcredit as Packcredit,
 b.lifnr as Lifnr,
 b.icgl as Icgl,
 b.oggl as Oggl,
 b.locallastchangedat as Locallastchangedat
}*/
