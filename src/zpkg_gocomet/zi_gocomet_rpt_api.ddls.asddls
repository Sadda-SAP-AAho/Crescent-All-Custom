@AbapCatalog.sqlViewName: 'ZGOCOMETAPI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GOCOMET REPORT-API'
define view ZI_GOCOMET_RPT_API
  as select distinct from zdt_deldash_hdr    as a
    inner join            I_DeliveryDocument as b on b.DeliveryDocument = a.delivery
    left outer join       ZCDS_DELI_INV      as c on c.ReferenceSDDocument = a.delivery
    left outer join       zdt_mpol_tmg       as d on d.polcodename = a.pol
    left outer join       ZCDS_GOCOMET_POL   as e on e.podcodename = a.pod //and e.transitdays = a.shpprtycode
    left outer join       zdt_shipline_tmg   as f on f.sline = a.shipline
{
  key cast( 'OCEAN' as abap.char( 5 ) ) as Delmode,
  key a.delivery                        as Refno,
  key a.contno                          as Trackno,
      f.slinename                       as Carrier,
      a.contno                          as Carnum,
      b.ActualGoodsMovementDate         as factDisdate,
      d.gotrackcode                     as Pol,
      e.gotrackcode                     as Pod,
      cast( '' as abap.char( 10 ) )     as Markcap,
      cast( '' as abap.char( 10 ) )     as Clntgrpcode,
      cast( '' as abap.char( 10 ) )     as Consgrpcode,
      cast( '' as abap.char( 10 ) )     as Consgrpcodes,
      f.slinegt                         as Carcode,
      cast( '' as abap.char( 10 ) )     as Sharewith,
      cast( '' as abap.char( 10 ) )     as Vesname,
      cast( '' as abap.char( 10 ) )     as Consize,
      cast( '' as abap.char( 10 ) )     as Contype,
      cast( '' as abap.char( 10 ) )     as Currency,
      cast( '' as abap.char( 10 ) )     as Destdetnchrg,
      cast( '' as abap.char( 10 ) )     as Destdetnfreedays,
      cast( '' as abap.char( 10 ) )     as Deststrtdate,
      cast( '' as abap.char( 10 ) )     as Destenddate,
      cast( '' as abap.char( 10 ) )     as Destdemrgchrg,
      cast( '' as abap.char( 10 ) )     as Destdemrgfreedays,
      cast( '' as abap.char( 10 ) )     as Demrgstrtdate,
      cast( '' as abap.char( 10 ) )     as Demrgenddate,
      cast( '' as abap.char( 10 ) )     as Destcombchrg,
      cast( '' as abap.char( 10 ) )     as Destcombfreedays,
      cast( '' as abap.char( 10 ) )     as Combstrtdate,
      cast( '' as abap.char( 10 ) )     as Combenddate,
      cast( '' as abap.char( 10 ) )     as Autodetctcarr,
      b.DeliveryDate                    as Deldate,
      c.BillingDocument                 as Invno,
      c.BillingDocumentDate             as Invdt

}
where
      a.canind <> 'X'
  and a.contno is not initial
