@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Variance Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_VARiANCE_RPT
  as select from    ZVNEWMON        as a
    left outer join ZVMELTINGSUM    as b  on  a.mmyyyy    = b.mmyyyy
                                          and a.Prctrclub = b.prctrclub
    left outer join ZVMELTACTSUM    as c  on  a.mmyyyy    = c.mmyyyy
                                          and a.Prctrclub = c.prctrclub
    left outer join ZVHARDCOKESUM   as d  on  a.mmyyyy    = d.mmyyyy
                                          and a.Prctrclub = d.prctrclub
    left outer join ZVHARDSTDSUM    as e  on  a.mmyyyy    = e.mmyyyy
                                          and a.Prctrclub = e.prctrclub
  //left outer join ZVSTORECOSTACT  as f  on  a.mmyyyy    = f.mmyyyy
    left outer join ZVSTORECOSTACT1 as f  on  a.mmyyyy    = f.mmyyyy
                                          and a.Prctrclub = f.prctrclub
    left outer join ZVSTORESTDSUM   as g1 on  a.mmyyyy    = g1.mmyyyy
                                          and a.Prctrclub = g1.prctrclub
    left outer join ZVELECACTSUM    as g  on  a.mmyyyy    = g.mmyyyy
                                          and a.Prctrclub = g.prctrclub
    left outer join ZVELECSTDSUM    as h  on  a.mmyyyy    = h.mmyyyy
                                          and a.Prctrclub = h.prctrclub
    left outer join ZVMODELACTSUM   as i  on  a.mmyyyy    = i.mmyyyy
                                          and a.Prctrclub = i.prctrclub
    left outer join ZVMODELSTDSUM   as j  on  a.mmyyyy    = j.mmyyyy
                                          and a.Prctrclub = j.prctrclub
    left outer join ZVFELTINGACTSUM as K  on  a.mmyyyy    = K.mmyyyy
                                          and a.Prctrclub = K.prctrclub
    left outer join ZVFLETINGSTDS   as l  on  a.mmyyyy    = l.mmyyyy
                                          and a.Prctrclub = l.prctrclub
    left outer join ZVMACHINEACTS   as m  on  a.mmyyyy    = m.mmyyyy
                                          and a.Prctrclub = m.prctrclub
    left outer join ZZVMACHINESUM   as n  on  a.mmyyyy    = n.mmyyyy
                                          and a.Prctrclub = n.prctrclub
    left outer join ZVPAINTACTSUM   as o  on  a.mmyyyy    = o.mmyyyy
                                          and a.Prctrclub = o.prctrclub
    left outer join ZVPAINTSTDS     as p  on  a.mmyyyy    = p.mmyyyy
                                          and a.Prctrclub = p.prctrclub
    left outer join ZVCOREACTSUM    as q  on  a.mmyyyy    = q.mmyyyy
                                          and a.Prctrclub = q.prctrclub
    left outer join ZVCORESTDSUM    as r  on  a.mmyyyy    = r.mmyyyy
                                          and a.Prctrclub = r.prctrclub
    left outer join ZVLABOURACTS    as s  on  a.mmyyyy    = s.mmyyyy
                                          and a.Prctrclub = s.prctrclub
    left outer join ZVLABOURSTDS    as t  on  a.mmyyyy    = t.mmyyyy
                                          and a.Prctrclub = t.prctrclub
    left outer join ZMETACTSUM      as u  on  a.mmyyyy    = u.mmyyyy
                                          and a.Prctrclub = u.prctrclub
    left outer join ZVMETINGSTDS    as v  on  a.mmyyyy    = v.mmyyyy
                                          and a.Prctrclub = v.prctrclub
    left outer join ZVMACHCOSTSUM   as w  on  a.mmyyyy    = w.mmyyyy
                                          and a.Prctrclub = w.prctrclub
{
      @EndUserText.label: 'Profit Center'
  key a.Prctrclub,
  key a.mmyyyy,
      @EndUserText.label: 'Months'
      case
      when substring(a.mmyyyy, 1, 2) = '01'
      then concat( 'Jan ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '02'
      then concat( 'Feb ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '03'
      then concat( 'Mar ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '04'
      then concat( 'Apr ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '05'
      then concat( 'May ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '06'
      then concat( 'Jun ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '07'
      then concat( 'Jul ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '08'
      then concat( 'Aug ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '09'
      then concat( 'Sep ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '10'
      then concat( 'Oct ' ,substring(a.mmyyyy, 3, 4) )
      when substring(a.mmyyyy, 1, 2) = '11'
      then concat( 'Nov ' ,substring(a.mmyyyy, 3, 4) )
       when substring(a.mmyyyy, 1, 2) = '12'
      then concat( 'Dec ' ,substring(a.mmyyyy, 3, 4) ) end                                                         as monyr,


      b.CompanyCodeCurrency,


      //Melting Loss
      @EndUserText.label: 'Melting Loss ( Actual )'
      cast(b.amt as abap.dec( 23, 2 ))                                                                             as meltlossact,
      @EndUserText.label: 'Melting Loss ( Standard )'
      cast(c.amt as abap.dec( 23,2))                                                                               as meltlossstd,
      @EndUserText.label: 'Melting Loss ( Diff )'
      coalesce( cast( b.amt as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( c.amt as abap.dec( 23,2 )) , 0 )         as meltdiff,

      //Hard Coke & DI Treatment
      @EndUserText.label: 'Hard Coke & DI Treatment ( Actual )'
      cast( d.hardcoke as abap.dec( 23,2) )                                                                        as hardcokeact,
      @EndUserText.label: 'Hard Coke & DI Treatment ( Standard )'
      cast( e.amt as abap.dec( 23,2) )                                                                             as hardcokestd,
      @EndUserText.label: 'Hard Coke & DI Treatment ( Diff )'
      coalesce( cast( d.hardcoke as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( e.amt as abap.dec( 23,2 )) , 0 )    as hardcokediff,

      //Store Cost
      @EndUserText.label: 'Store Cost ( Actual )'
      cast(f.store  as abap.dec( 23,2) )                                                                           as storecost,
      @EndUserText.label: 'Store Cost ( Standard )'
      cast(g1.storestd as abap.dec( 23,2) )                                                                        as storestd,
      @EndUserText.label: 'Store Cost ( Diff )'
      coalesce( cast( f.store as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( g1.storestd as abap.dec( 23,2 )) , 0 ) as storediff,

      //Electricity Expenses
      @EndUserText.label: 'Electricity Expenses ( Actual )'
      cast( g.elecact as abap.dec( 23,2))                                                                          as electact,
      @EndUserText.label: 'Electricity Expenses ( Standard )'
      cast(h.elect  as abap.dec( 23,2))                                                                            as electstd,
      @EndUserText.label: 'Electricity Expenses ( Diff )'
      coalesce( cast( g.elecact as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( h.elect as abap.dec( 23,2 )) , 0 )   as electdiff,


      //Moulding recovery
      @EndUserText.label: 'Moulding recovery ( Actual )'
      cast(i.model as abap.dec( 23,2) )                                                                            as modelact,
      @EndUserText.label: 'Moulding recovery ( Stadard )'
      cast(j.model           as abap.dec( 23,2) )                                                                  as modelstd,
      @EndUserText.label: 'Moulding recovery ( Diff )'
      coalesce( cast( i.model as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( j.model as abap.dec( 23,2 )) , 0 )     as modeldiff,


      //Fetling expenses
      @EndUserText.label: 'Fetling expenses ( Actual )'
      cast(K.feltact           as abap.dec( 23,2) )                                                                as feltact,
      @EndUserText.label: 'Fetling expenses ( Standard )'
      cast(l.feltsum  as abap.dec( 23,2) )                                                                         as feltstd,
      @EndUserText.label: 'Fetling expenses ( Diff )'
      coalesce( cast( K.feltact as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( l.feltsum as abap.dec( 23,2 )) , 0 ) as feltdiff,

      //Machining Recovery
      @EndUserText.label: 'Machining Recovery ( Actual )'
      cast(m.machine    as abap.dec( 23,2) )                                                                       as machineact,
      @EndUserText.label: 'Machining Recovery ( Standard )'
      cast(n.machine    as abap.dec( 23,2) )                                                                       as machinestd,
      @EndUserText.label: 'Machining Recovery ( Diff )'
      coalesce( cast( m.machine as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( n.machine as abap.dec( 23,2 )) , 0 ) as machdiff,

      //Painting Expenses
      @EndUserText.label: 'Painting Expenses ( Actual )'
      cast(o.amt     as abap.dec( 23,2) )                                                                          as paintact,
      @EndUserText.label: 'Painting Expenses ( Standard )'
      cast(p.paint      as abap.dec( 23,2) )                                                                       as paintstd,
      @EndUserText.label: 'Painting Expenses ( Diff )'
      coalesce( cast( o.amt as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( p.paint as abap.dec( 23,2 )) , 0 )       as paintdiff,

      //Core Labor
      @EndUserText.label: 'Core Labor ( Actual )'
      cast(q.core      as abap.dec( 23,2) )                                                                        as coreact,
      @EndUserText.label: 'Core Labor ( Standard )'
      cast(r.core         as abap.dec( 23,2) )                                                                     as corestd,
      @EndUserText.label: 'Core Labor ( Diff )'
      coalesce( cast( q.core as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( r.core as abap.dec( 23,2 )) , 0 )       as corediff,

      //Labor Charges
      @EndUserText.label: 'Labor Charges ( Actual )'
      cast( s.labour   as abap.dec( 23,2) )                                                                        as labouract,
      @EndUserText.label: 'Labor Charges ( Standard )'
      cast( t.labour  as abap.dec( 23,2 ) )                                                                        as labourstd,
      @EndUserText.label: 'Labor Charges ( Diff )'
      coalesce( cast( s.labour as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( t.labour as abap.dec( 23,2 )) , 0 )   as labourdiff,

      //Metling Labor
      @EndUserText.label: 'Metling Labor ( Actual )'
      cast(u.meting   as abap.dec( 23,2) )                                                                         as metlingact,
      @EndUserText.label: 'Metling Labor ( Standard )'
      cast( v.meting  as abap.dec( 23,2) )                                                                         as metlingstd,
      @EndUserText.label: 'Metling Labor ( Diff )'
      coalesce( cast( u.meting as abap.dec( 23,2 )) , 0 ) -  coalesce( cast( v.meting as abap.dec( 23,2 )) , 0 )   as metlingdiff,

      //Machine Cost
      @EndUserText.label: 'Machine Cost ( Standard )'
      cast(w.mach      as abap.dec( 23,2) )                                                                        as machinecost
}
