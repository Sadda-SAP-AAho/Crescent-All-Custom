@AbapCatalog.sqlViewName: 'ZGOCOMET'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GoComet Upload Report'
define view ZCDS_GOCOMET_RPT
  as select distinct from zdt_deldash_hdr    as a
    inner join            I_DeliveryDocument as b on b.DeliveryDocument = a.delivery
    left outer join       ZCDS_DELI_INV      as c on c.ReferenceSDDocument = a.delivery
    left outer join       zdt_mpol_tmg       as d on d.polcodename = a.pol
    left outer join       ZCDS_GOCOMET_POL   as e on e.podcodename = a.pod //and e.transitdays = a.shpprtycode
{
  key cast( 'OCEAN' as abap.char( 5 ) ) as Delmode,
  key a.delivery                        as Refno,
  key a.contno                          as Trackno,
      a.shipline                        as Carrier,
      a.contno                          as Carnum,
      b.ActualGoodsMovementDate         as Disdate,
      d.gotrackcode                     as Pol,
      e.gotrackcode                     as Pod,
      cast( '' as abap.char( 10 ) )     as Markcap,
      cast( '' as abap.char( 10 ) )     as Clntgrpcode,
      cast( '' as abap.char( 10 ) )     as Consgrpcode,
      a.shipline                        as Carcode,
      cast( '' as abap.char( 10 ) )     as Vesname,
      cast( '' as abap.char( 10 ) )     as Consize,
      cast( '' as abap.char( 10 ) )     as Contype,
      cast( '' as abap.char( 10 ) )     as autocar,
      b.DeliveryDate                    as Deldate,
      c.BillingDocument                 as Invno,
      c.BillingDocumentDate             as Invdt

}
where
      a.canind <> 'X'
  and a.contno is not initial
