@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View of Estimate Vacuum Reg'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZI_ESTVACREG
  as select distinct from zdt_estvacreg_n as a
{
  key a.id,
  key a.rfqno,
      a.rfqdate,
      a.matcd,
      a.rejection,
      a.tolerance,
      a.margin,
      a.amtmrgn,
      a.cntwgt,
      a.fxdcst_cal,
      a.fxdcst_ue,
      a.line,
      a.boxsize1,
      a.boxsize2,
      a.annualqty,
      a.mouldspd,
      a.reqweight,
      a.noofcav,
      a.yield,
      a.addacccost,
      a.drillperfacing,
      a.srfcarea,
      a.meltingcst,
      a.chrgingcst,
      a.metalcst,
      ( case when a.line = 'SMALL VACUUM' then cast( '1720'  as abap.dec(15,3) )
           when a.line = 'BIG VACUUM' then cast( '3440' as abap.dec(15,3) )
           when a.line = 'MANIPULATOR'  then cast( '6000' as abap.dec(15,3) )
           when a.line = 'FLEXILINE ( 3 * 3 )' then cast( '9460' as abap.dec(15,3) )
           when a.line = 'FLEXILINE ( 4.5 * 3 )' then cast( '9460' as abap.dec(15,3) )
           else cast( '0' as abap.dec(15,3) )
      end )                       as elccst,
      a.labmldperbx,
      cast( abs( division(
      ( case when a.line = 'SMALL VACUUM' then cast( '4000'  as abap.dec(15,3) )
           when a.line = 'BIG VACUUM' then cast( '8000' as abap.dec(15,3) )
           when a.line = 'MANIPULATOR'  then cast( '14000' as abap.dec(15,3) )
           when a.line = 'FLEXILINE ( 3 * 3 )' then cast( '22000' as abap.dec(15,3) )
           when a.line = 'FLEXILINE ( 4.5 * 3 )' then cast( '22000' as abap.dec(15,3) )
           else cast( '0' as abap.dec(15,3) )
      end )
      , ( case when coalesce( a.rejection, 0 ) = 1
               then cast( '1' as abap.dec(15,3) )
          else cast( '1' as abap.dec(15,3) ) - coalesce( a.rejection, 0 )
          end )
      , 3 ) ) as abap.dec(15,3) ) as mldcst,
      a.mntcstperpc,
      a.fetcstperpc,
      a.packngcst,
      a.paintprcst,
      a.sellexpn,
      a.acccavity,
      a.packrateperkg,
      a.exchngrt,
      a.curr,
      a.corecstcav,
      a.agreedincoterm,
      a.freightchrg,
      a.freightrmrks,
      a.fclwgt
}
