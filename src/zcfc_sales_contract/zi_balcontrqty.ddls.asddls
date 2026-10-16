@AbapCatalog.sqlViewName: 'ZBALCONTRQTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Balance Contract Qty'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BALCONTRQTY
  as select distinct from I_SalesContractItem as a
    inner join            I_SalesContract     as b on a.SalesContract = b.SalesContract
    inner join            ZI_TTLORDRQTY       as c on  a.SalesContract     = c.Sales_Cont_No
                                                   and a.SalesContractItem = c.SalesContractItem
                                                   and a.Material          = c.Mat_Code
    left outer join       I_Product           as d on a.Material = d.Product
    inner join            I_UnitOfMeasure     as e on a.TargetQuantityUnit = e.UnitOfMeasure


{
  key a.SalesContract                                                                                                                                                                                                               as Sales_Cont_No,
      a.SalesContractItem,
      a.Material                                                                                                                                                                                                                    as Mat_Code,
      a.TargetQuantityUnit,
      cast( a.TargetQuantity  as abap.dec( 13, 3) )                                                                                                                                                                                 as Contr_Qty,
      cast( c.Total_Ord_Qty as abap.dec( 13, 3) )                                                                                                                                                                                   as Total_Ord_Qty,
      ( cast( coalesce( a.TargetQuantity,0 )  as abap.dec( 13, 3) ) - cast( coalesce( c.Total_Ord_Qty,0 ) as abap.dec( 13, 3) ) )                                                                                                   as Bal_Qty,
      e.UnitOfMeasure_E,
      ( ( cast( coalesce( a.TargetQuantity,0 )  as abap.dec( 13, 3) ) - cast( coalesce( c.Total_Ord_Qty,0 ) as abap.dec( 13, 3) ) ) * cast( coalesce(d.NetWeight,0 ) as abap.dec( 13, 3) ) )                                        as Bal_Wt,
      a.ItemWeightUnit,
      cast( coalesce( a.NetPriceAmount,0) as abap.dec( 13, 3) ) * ( cast( coalesce( a.TargetQuantity,0 )  as abap.dec( 13, 3) ) - cast( coalesce( c.Total_Ord_Qty,0 ) as abap.dec( 13, 3) ) )                                       as Bal_Val_DC,
      cast( coalesce( a.NetPriceAmount,0) as abap.dec( 13, 3) ) * ( cast( coalesce( a.TargetQuantity,0 )  as abap.dec( 13, 3) ) - cast( coalesce( c.Total_Ord_Qty,0 ) as abap.dec( 13, 3) ) ) * coalesce(a.PriceDetnExchangeRate,0) as Bal_Val_INR
}
