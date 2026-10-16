@AbapCatalog.sqlViewName: 'ZREJRSNFL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason Anlysis-Final'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRSNFL
  as select from ZI_REJRSNBASIC       as a
    inner join   ZI_REJRESNBEND       as b on  a.Shpflrno = b.Shpflrno
                                           and a.itemkey  = b.itemkey
                                           and a.orderkey = b.orderkey
                                           and a.Plant    = b.Plant
                                           and a.Dept     = b.Dept
                                           and a.Opr      = b.Opr
                                           and a.Cont     = b.Cont
                                           and a.Matnr    = b.Matnr

    inner join   ZI_REJRESNBLOW       as c on  a.Shpflrno = c.Shpflrno
                                           and a.itemkey  = c.itemkey
                                           and a.orderkey = c.orderkey
                                           and a.Plant    = c.Plant
                                           and a.Dept     = c.Dept
                                           and a.Opr      = c.Opr
                                           and a.Cont     = c.Cont
                                           and a.Matnr    = c.Matnr

    inner join   ZI_REJRESNCICAST     as d on  a.Shpflrno = d.Shpflrno
                                           and a.itemkey  = d.itemkey
                                           and a.orderkey = d.orderkey
                                           and a.Plant    = d.Plant
                                           and a.Dept     = d.Dept
                                           and a.Opr      = d.Opr
                                           and a.Cont     = d.Cont
                                           and a.Matnr    = d.Matnr

    inner join   ZI_REJRESNCHPLT      as e on  a.Shpflrno = e.Shpflrno
                                           and a.itemkey  = e.itemkey
                                           and a.orderkey = e.orderkey
                                           and a.Plant    = e.Plant
                                           and a.Dept     = e.Dept
                                           and a.Opr      = e.Opr
                                           and a.Cont     = e.Cont
                                           and a.Matnr    = e.Matnr

    inner join   ZI_REJRESNCLDSHT     as f on  a.Shpflrno = f.Shpflrno
                                           and a.itemkey  = f.itemkey
                                           and a.orderkey = f.orderkey
                                           and a.Plant    = f.Plant
                                           and a.Dept     = f.Dept
                                           and a.Opr      = f.Opr
                                           and a.Cont     = f.Cont
                                           and a.Matnr    = f.Matnr

    inner join   ZI_REJRESNCRSHFT     as g on  a.Shpflrno = g.Shpflrno
                                           and a.itemkey  = g.itemkey
                                           and a.orderkey = g.orderkey
                                           and a.Plant    = g.Plant
                                           and a.Dept     = g.Dept
                                           and a.Opr      = g.Opr
                                           and a.Cont     = g.Cont
                                           and a.Matnr    = g.Matnr

    inner join   ZI_REJRESNCRNRDFCT   as h on  a.Shpflrno = h.Shpflrno
                                           and a.itemkey  = h.itemkey
                                           and a.orderkey = h.orderkey
                                           and a.Plant    = h.Plant
                                           and a.Dept     = h.Dept
                                           and a.Opr      = h.Opr
                                           and a.Cont     = h.Cont
                                           and a.Matnr    = h.Matnr

    inner join   ZI_REJRESNCRACK      as i on  a.Shpflrno = i.Shpflrno
                                           and a.itemkey  = i.itemkey
                                           and a.orderkey = i.orderkey
                                           and a.Plant    = i.Plant
                                           and a.Dept     = i.Dept
                                           and a.Opr      = i.Opr
                                           and a.Cont     = i.Cont
                                           and a.Matnr    = i.Matnr

    inner join   ZI_REJRESNDDSTCK     as j on  a.Shpflrno = j.Shpflrno
                                           and a.itemkey  = j.itemkey
                                           and a.orderkey = j.orderkey
                                           and a.Plant    = j.Plant
                                           and a.Dept     = j.Dept
                                           and a.Opr      = j.Opr
                                           and a.Cont     = j.Cont
                                           and a.Matnr    = j.Matnr

    inner join   ZI_REJRESNDESCHNG    as k on  a.Shpflrno = k.Shpflrno
                                           and a.itemkey  = k.itemkey
                                           and a.orderkey = k.orderkey
                                           and a.Plant    = k.Plant
                                           and a.Dept     = k.Dept
                                           and a.Opr      = k.Opr
                                           and a.Cont     = k.Cont
                                           and a.Matnr    = k.Matnr

    inner join   ZI_REJRESNFLTPRBLM   as l on  a.Shpflrno = l.Shpflrno
                                           and a.itemkey  = l.itemkey
                                           and a.orderkey = l.orderkey
                                           and a.Plant    = l.Plant
                                           and a.Dept     = l.Dept
                                           and a.Opr      = l.Opr
                                           and a.Cont     = l.Cont
                                           and a.Matnr    = l.Matnr

    inner join   ZI_REJRESNINSSHFT    as m on  a.Shpflrno = m.Shpflrno
                                           and a.itemkey  = m.itemkey
                                           and a.orderkey = m.orderkey
                                           and a.Plant    = m.Plant
                                           and a.Dept     = m.Dept
                                           and a.Opr      = m.Opr
                                           and a.Cont     = m.Cont
                                           and a.Matnr    = m.Matnr

    inner join   ZI_REJRESNEXMTL      as n on  a.Shpflrno = n.Shpflrno
                                           and a.itemkey  = n.itemkey
                                           and a.orderkey = n.orderkey
                                           and a.Plant    = n.Plant
                                           and a.Dept     = n.Dept
                                           and a.Opr      = n.Opr
                                           and a.Cont     = n.Cont
                                           and a.Matnr    = n.Matnr

    inner join   ZI_REJRESNFLNBRKN    as o on  a.Shpflrno = o.Shpflrno
                                           and a.itemkey  = o.itemkey
                                           and a.orderkey = o.orderkey
                                           and a.Plant    = o.Plant
                                           and a.Dept     = o.Dept
                                           and a.Opr      = o.Opr
                                           and a.Cont     = o.Cont
                                           and a.Matnr    = o.Matnr

    inner join   ZI_REJRESNHARD       as p on  a.Shpflrno = p.Shpflrno
                                           and a.itemkey  = p.itemkey
                                           and a.orderkey = p.orderkey
                                           and a.Plant    = p.Plant
                                           and a.Dept     = p.Dept
                                           and a.Opr      = p.Opr
                                           and a.Cont     = p.Cont
                                           and a.Matnr    = p.Matnr

    inner join   ZI_REJRESNINTRNLDFCT as q on  a.Shpflrno = q.Shpflrno
                                           and a.itemkey  = q.itemkey
                                           and a.orderkey = q.orderkey
                                           and a.Plant    = q.Plant
                                           and a.Dept     = q.Dept
                                           and a.Opr      = q.Opr
                                           and a.Cont     = q.Cont
                                           and a.Matnr    = q.Matnr
                                           
    inner join   ZI_REJRESNLESSWT as r on  a.Shpflrno = r.Shpflrno
                                           and a.itemkey  = r.itemkey
                                           and a.orderkey = r.orderkey
                                           and a.Plant    = r.Plant
                                           and a.Dept     = r.Dept
                                           and a.Opr      = r.Opr
                                           and a.Cont     = r.Cont
                                           and a.Matnr    = r.Matnr
                                           
    inner join   ZI_REJRESNLDTSTFL as s on  a.Shpflrno = s.Shpflrno
                                           and a.itemkey  = s.itemkey
                                           and a.orderkey = s.orderkey
                                           and a.Plant    = s.Plant
                                           and a.Dept     = s.Dept
                                           and a.Opr      = s.Opr
                                           and a.Cont     = s.Cont
                                           and a.Matnr    = s.Matnr
                                           
    inner join   ZI_REJRESNLCKPRBLM as t on  a.Shpflrno = t.Shpflrno
                                           and a.itemkey  = t.itemkey
                                           and a.orderkey = t.orderkey
                                           and a.Plant    = t.Plant
                                           and a.Dept     = t.Dept
                                           and a.Opr      = t.Opr
                                           and a.Cont     = t.Cont
                                           and a.Matnr    = t.Matnr

{
  key a.Shpflrno,
  key a.itemkey,
  key a.orderkey,
      a.Shpflrdt,
      a.Plant,
      a.Dept,
      a.Deptname,
      a.Opr,
      a.Oprname,
      a.Cont,
      a.Contname,
      a.Matnr,
      a.Maktx,
      a.Profit_Center,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.UnitWt,
      a.Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Totcast,
      a.Meins,
      a.Total_Cast_Wt,
      a.Goodcast,
      a.Total_Good_Cast_Wt,
      a.Total_RejQty,
      a.Total_Rej_Wt,

      cast( ( coalesce( b.Total_Qty1_Bend,0 ) + coalesce( b.Total_Qty2_Bend,0 ) + coalesce( b.Total_Qty3_Bend,0 ) +
      coalesce( b.Total_Qty4_Bend,0 ) + coalesce( b.Total_Qty5_Bend,0 ) + coalesce( b.Total_Qty6_Bend,0 ) +
      coalesce( b.Total_Qty7_Bend,0 ) + coalesce( b.Total_Qty8_Bend,0 ) + coalesce( b.Total_Qty9_Bend,0 ) ) as abap.dec( 13, 3) )                   as TOTAL_BEND,

      cast( ( coalesce( c.Total_Qty1_Blow,0 ) + coalesce( c.Total_Qty2_Blow,0 ) + coalesce( c.Total_Qty3_Blow,0 ) +
      coalesce( c.Total_Qty4_Blow,0 ) + coalesce( c.Total_Qty5_Blow,0 ) + coalesce( c.Total_Qty6_Blow,0 ) +
      coalesce( c.Total_Qty7_Blow,0 ) + coalesce( c.Total_Qty8_Blow,0 ) + coalesce( c.Total_Qty9_Blow,0 ) ) as abap.dec( 13, 3) )                   as TOTAL_BLOW,

      cast( ( coalesce( d.Total_Qty1_CICast,0 ) + coalesce( d.Total_Qty2_CICast,0 ) + coalesce( d.Total_Qty3_CICast,0 ) +
      coalesce( d.Total_Qty4_CICast,0 ) + coalesce( d.Total_Qty5_CICast,0 ) + coalesce( d.Total_Qty6_CICast,0 ) +
      coalesce( d.Total_Qty7_CICast,0 ) + coalesce( d.Total_Qty8_CICast,0 ) + coalesce( d.Total_Qty9_CICast,0 ) ) as abap.dec( 13, 3) )             as TOTAL_CI_CAST,

      cast( ( coalesce( e.Total_Qty1_Chaplet,0 ) + coalesce( e.Total_Qty2_Chaplet,0 ) + coalesce( e.Total_Qty3_Chaplet,0 ) +
      coalesce( e.Total_Qty4_Chaplet,0 ) + coalesce( e.Total_Qty5_Chaplet,0 ) + coalesce( e.Total_Qty6_Chaplet,0 ) +
      coalesce( e.Total_Qty7_Chaplet,0 ) + coalesce( e.Total_Qty8_Chaplet,0 ) + coalesce( e.Total_Qty9_Chaplet,0 ) ) as abap.dec( 13, 3) )          as TOTAL_CHAPLET,

      cast( ( coalesce( f.Total_Qty1_ColdShut,0 ) + coalesce( f.Total_Qty3_ColdShut,0 ) + coalesce( f.Total_Qty3_ColdShut,0 ) +
      coalesce( f.Total_Qty4_ColdShut,0 ) + coalesce( f.Total_Qty5_ColdShut,0 ) + coalesce( f.Total_Qty6_ColdShut,0 ) +
      coalesce( f.Total_Qty7_ColdShut,0 ) + coalesce( f.Total_Qty8_ColdShut,0 ) + coalesce( f.Total_Qty9_ColdShut,0 ) ) as abap.dec( 13, 3) )       as TOTAL_COLDSHUT,

      cast( ( coalesce( g.Total_Qty1_CoreShift,0 ) + coalesce( g.Total_Qty2_CoreShift,0 ) + coalesce( g.Total_Qty3_CoreShift,0 ) +
      coalesce( g.Total_Qty4_CoreShift,0 ) + coalesce( g.Total_Qty5_CoreShift,0 ) + coalesce( g.Total_Qty6_CoreShift,0 ) +
      coalesce( g.Total_Qty7_CoreShift,0 ) + coalesce( g.Total_Qty8_CoreShift,0 ) + coalesce( g.Total_Qty9_CoreShift,0 ) ) as abap.dec( 13, 3) )    as TOTAL_CORESHIFT,

      cast( ( coalesce( h.Total_Qty1_CrnrDfct,0 ) + coalesce( h.Total_Qty2_CrnrDfct,0 ) + coalesce( h.Total_Qty3_CrnrDfct,0 ) +
      coalesce( h.Total_Qty4_CrnrDfct,0 ) + coalesce( h.Total_Qty5_CrnrDfct,0 ) + coalesce( h.Total_Qty6_CrnrDfct,0 ) +
      coalesce( h.Total_Qty7_CrnrDfct,0 ) + coalesce( h.Total_Qty8_CrnrDfct,0 ) + coalesce( h.Total_Qty9_CrnrDfct,0 ) ) as abap.dec( 13, 3) )       as TOTAL_CORNERDEFCT,

      cast( ( coalesce( i.Total_Qty1_Crack,0 ) + coalesce( i.Total_Qty2_Crack,0 ) + coalesce( i.Total_Qty3_Crack,0 ) +
      coalesce( i.Total_Qty4_Crack,0 ) + coalesce( i.Total_Qty5_Crack,0 ) + coalesce( i.Total_Qty6_Crack,0 ) +
      coalesce( i.Total_Qty7_Crack,0 ) + coalesce( i.Total_Qty8_Crack,0 ) + coalesce( i.Total_Qty9_Crack,0 ) ) as abap.dec( 13, 3) )                as TOTAL_CRACK,

      cast( ( coalesce( j.Total_Qty1_DDSTCK,0 ) + coalesce( j.Total_Qty2_DDSTCK,0 ) + coalesce( j.Total_Qty2_DDSTCK,0 ) +
      coalesce( j.Total_Qty2_DDSTCK,0 ) + coalesce( j.Total_Qty2_DDSTCK,0 ) + coalesce( j.Total_Qty2_DDSTCK,0 ) +
      coalesce( j.Total_Qty2_DDSTCK,0 ) + coalesce( j.Total_Qty2_DDSTCK,0 ) + coalesce( j.Total_Qty2_DDSTCK,0 ) ) as abap.dec( 13, 3) )             as TOTAL_DEADSTOCK,

      cast( ( coalesce( k.Total_Qty1_DESCHNG,0 ) + coalesce( k.Total_Qty2_DESCHNG,0 ) + coalesce( k.Total_Qty3_DESCHNG,0 ) +
      coalesce( k.Total_Qty4_DESCHNG,0 ) + coalesce( k.Total_Qty5_DESCHNG,0 ) + coalesce( k.Total_Qty6_DESCHNG,0 ) +
      coalesce( k.Total_Qty7_DESCHNG,0 ) + coalesce( k.Total_Qty8_DESCHNG,0 ) + coalesce( k.Total_Qty9_DESCHNG,0 ) ) as abap.dec( 13, 3) )          as TOTAL_DESCHNG,

      cast( ( coalesce( l.Total_Qty1_FLTPRBLM,0 ) + coalesce( l.Total_Qty2_FLTPRBLM,0 ) + coalesce( l.Total_Qty3_FLTPRBLM,0 ) +
      coalesce( l.Total_Qty4_FLTPRBLM,0 ) + coalesce( l.Total_Qty5_FLTPRBLM,0 ) + coalesce( l.Total_Qty6_FLTPRBLM,0 ) +
      coalesce( l.Total_Qty7_FLTPRBLM,0 ) + coalesce( l.Total_Qty8_FLTPRBLM,0 ) + coalesce( l.Total_Qty8_FLTPRBLM,0 ) ) as abap.dec( 13, 3) )       as TOTAL_FLTPRBLM,

      cast( ( coalesce( m.Total_Qty1_InsShft,0 ) + coalesce( m.Total_Qty2_InsShft,0 ) + coalesce( m.Total_Qty3_InsShft,0 ) +
      coalesce( m.Total_Qty4_InsShft,0 ) + coalesce( m.Total_Qty5_InsShft,0 ) + coalesce( m.Total_Qty6_InsShft,0 ) +
      coalesce( m.Total_Qty7_InsShft,0 ) + coalesce( m.Total_Qty8_InsShft,0 ) + coalesce( m.Total_Qty9_InsShft,0 ) ) as abap.dec( 13, 3) )          as TOTAL_INSERTSHIFT,

      cast( ( coalesce( n.Total_Qty1_EXMTL,0 ) + coalesce( n.Total_Qty2_EXMTL,0 ) + coalesce( n.Total_Qty3_EXMTL,0 ) +
      coalesce( n.Total_Qty4_EXMTL,0 ) + coalesce( n.Total_Qty5_EXMTL,0 ) + coalesce( n.Total_Qty6_EXMTL,0 ) +
      coalesce( n.Total_Qty7_EXMTL,0 ) + coalesce( n.Total_Qty8_EXMTL,0 ) + coalesce( n.Total_Qty9_EXMTL,0 ) ) as abap.dec( 13, 3) )                as TOTAL_EXTRAMETAL,

      cast( ( coalesce( o.Total_Qty1_FlnBrkn,0 ) + coalesce( o.Total_Qty2_FlnBrkn,0 ) + coalesce( o.Total_Qty3_FlnBrkn,0 ) +
      coalesce( o.Total_Qty4_FlnBrkn,0 ) + coalesce( o.Total_Qty5_FlnBrkn,0 ) + coalesce( o.Total_Qty6_FlnBrkn,0 ) +
      coalesce( o.Total_Qty7_FlnBrkn,0 ) + coalesce( o.Total_Qty8_FlnBrkn,0 ) + coalesce( o.Total_Qty9_FlnBrkn,0 ) ) as abap.dec( 13, 3) )          as TOTAL_FLANGEBROKEN,

      cast( ( coalesce( p.Total_Qty1_HARD,0 ) + coalesce( p.Total_Qty2_HARD,0 ) + coalesce( p.Total_Qty3_HARD,0 ) +
      coalesce( p.Total_Qty4_HARD,0 ) + coalesce( p.Total_Qty5_HARD,0 ) + coalesce( p.Total_Qty6_HARD,0 ) +
      coalesce( p.Total_Qty7_HARD,0 ) + coalesce( p.Total_Qty8_HARD,0 ) + coalesce( p.Total_Qty9_HARD,0 ) ) as abap.dec( 13, 3) ) as TOTAL_HARD,
      
      cast( ( coalesce( q.Total_Qty1_IntrnlDfct,0 ) + coalesce( q.Total_Qty2_IntrnlDfct,0 ) + coalesce( q.Total_Qty3_IntrnlDfct,0 ) +
      coalesce( q.Total_Qty4_IntrnlDfct,0 ) + coalesce( q.Total_Qty5_IntrnlDfct,0 ) + coalesce( q.Total_Qty6_IntrnlDfct,0 ) +
      coalesce( q.Total_Qty7_IntrnlDfct,0 ) + coalesce( q.Total_Qty8_IntrnlDfct,0 ) + coalesce( q.Total_Qty9_IntrnlDfct,0 ) ) as abap.dec( 13, 3) ) as TOTAL_INTRNLDFCT,
      
      cast( ( coalesce( r.Total_Qty1_LessWt,0 ) + coalesce( r.Total_Qty2_LessWt,0 ) + coalesce( r.Total_Qty3_LessWt,0 ) +
      coalesce( r.Total_Qty4_LessWt,0 ) + coalesce( r.Total_Qty5_LessWt,0 ) + coalesce( r.Total_Qty6_LessWt,0 ) +
      coalesce( r.Total_Qty7_LessWt,0 ) + coalesce( r.Total_Qty8_LessWt,0 ) + coalesce( r.Total_Qty9_LessWt,0 ) ) as abap.dec( 13, 3) ) as TOTAL_LESSWT,
      
      cast( ( coalesce( s.Total_Qty1_LDTSTFL,0 ) + coalesce( s.Total_Qty2_LDTSTFL,0 ) + coalesce( s.Total_Qty3_LDTSTFL,0 ) +
      coalesce( s.Total_Qty4_LDTSTFL,0 ) + coalesce( s.Total_Qty5_LDTSTFL,0 ) + coalesce( s.Total_Qty6_LDTSTFL,0 ) +
      coalesce( s.Total_Qty7_LDTSTFL,0 ) + coalesce( s.Total_Qty8_LDTSTFL,0 ) + coalesce( s.Total_Qty9_LDTSTFL,0 ) ) as abap.dec( 13, 3) ) as TOTAL_LDTSTFL,
      
      cast( ( coalesce( t.Total_Qty1_LCKPRBLM,0 ) + coalesce( t.Total_Qty2_LCKPRBLM,0 ) + coalesce( t.Total_Qty3_LCKPRBLM,0 ) +
      coalesce( t.Total_Qty4_LCKPRBLM,0 ) + coalesce( t.Total_Qty5_LCKPRBLM,0 ) + coalesce( t.Total_Qty6_LCKPRBLM,0 ) +
      coalesce( t.Total_Qty7_LCKPRBLM,0 ) + coalesce( t.Total_Qty8_LCKPRBLM,0 ) + coalesce( t.Total_Qty9_LCKPRBLM,0 ) ) as abap.dec( 13, 3) ) as TOTAL_LOCKPRBLM
      
      
}
