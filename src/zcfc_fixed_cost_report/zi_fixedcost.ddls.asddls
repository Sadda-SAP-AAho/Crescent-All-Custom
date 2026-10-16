@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fixed Code Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_FIXEDCOST
  as select distinct from ZI_FIXEDCOST_BASIC as a
    left outer join       ZI_COSTPERKGCAL    as b on  a.Hedmaterial = b.Hedmaterial
                                                  and a.Plant       = b.Plant
{
  key a.Hedmaterial,
  key a.Head_MatName,
  key a.Plant,
  key a.moc,
  key a.cuscode,
  key a.Bomlevel,
  key a.Component,
      a.Child_MatName,
      a.Child_Oprn_Code,
      a.Child_Oprn,
      a.ParentQty,
      a.Unit,
      cast ( a.ParentNetwt as abap.dec(16,3) )                                                as ParentNetwt,
      a.ParentNetWtUnit,
      a.Childqty,
      a.Bomitemqtyunit,
      cast ( a.ChildNetwt as abap.dec(16,3) )                                                 as ChildNetwt,
      a.ChildWtUnit,
      cast ( a.Total_Wt as abap.dec(16,3) )                                                   as Total_Wt,
      a.typeofmould,
      a.qtyperbox,
      a.Mouldlinespd,
      a.Rate,
      cast ( a.FixedCost as abap.dec(16,3) )                                                  as FixedCost,
      a.ratefc2,
      cast ( a.FixedCost2 as abap.dec(16,3) )                                                 as FixedCost2,

      ( case when ( a.Plant = '1400' and a.typeofmould = 'SINTO' and ( a.qtyperbox is not null or a.qtyperbox <> 0 ) )
             then cast( abs( division( cast( abs( division( b.Total_FC1, b.ParentNetwt, 3 ) ) as abap.dec( 9,3 ) ), a.qtyperbox, 3 ) ) as abap.dec( 9,3 ) )

             when ( a.Plant = '1400' and a.typeofmould = 'SINTO' and ( a.qtyperbox is null or a.qtyperbox = 0 ) )
             then cast( abs( division( cast( abs( division( b.Total_FC1, b.ParentNetwt, 3 ) ) as abap.dec( 9,3 ) ), 1, 3 ) ) as abap.dec( 9,3 ) )

        else
            cast( abs( division( b.Total_FC1, b.ParentNetwt, 3 ) ) as abap.dec( 9,3 ) ) end ) as CostKgFC1,

            cast( abs( division( b.Total_FC2, b.ParentNetwt, 3 ) ) as abap.dec( 9,3 ) ) as CostKgFC2
}
