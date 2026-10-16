@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Shortage - Reqd Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_REQD_MUL
  as select distinct from ZCDS_PACK_MAT_DET   as a
    left outer join       I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                                   and h.Plant   = a.plant
{
      //  key a.plant,
  key (case when h.SpecialProcurementType = '40' then '1100'
                  else a.plant end)          as Plant,
  key a.hedmaterial,
  key a.component,
      //  case when a.qtyz027 is not initial and a.qtyZ026 is not initial and a.qtyZ028 is not initial
      //       then cast( ( cast( ( a.qtyz027 * a.qtyZ026 ) as abap.dec( 13, 3 ) )
      //                    * cast( ( a.qtyZ028 * a.qtyz025 ) as abap.dec( 13, 3 ) ) ) as abap.dec( 13, 3 ) )
      //       when a.qtyz027 is not initial and a.qtyZ026 is not initial
      //       then cast( ( cast( ( a.qtyz027 * a.qtyZ026 ) as abap.dec( 13, 3 ) ) * a.qtyz025 ) as abap.dec( 13, 3 ) )
      //       when a.qtyz027 is not initial and a.qtyZ028 is not initial
      //       then cast( ( cast( ( a.qtyz027 * a.qtyZ028 ) as abap.dec( 13, 3 ) ) * a.qtyz025 ) as abap.dec( 13, 3 ) )
      //       when a.qtyZ026 is not initial and a.qtyZ028 is not initial
      //       then cast( ( cast( ( a.qtyZ026 * a.qtyZ028 ) as abap.dec( 13, 3 ) ) * a.qtyz025 ) as abap.dec( 13, 3 ) )
      //       when a.qtyZ026 is not initial
      //       then cast( ( a.qtyZ026 * a.qtyz025 ) as abap.dec( 13, 3 ) )
      //       when a.qtyz027 is not initial
      //       then cast( ( a.qtyz027 * a.qtyz025 ) as abap.dec( 13, 3 ) )
      //       when a.qtyZ028 is not initial
      //       then cast( ( a.qtyZ028 * a.qtyz025 ) as abap.dec( 13, 3 ) )
      //       else cast( a.qtyz025 as abap.dec( 13, 3 ) ) end as qty
      cast( a.qtyz025 as abap.dec( 13, 3 ) ) as qty

}
where
      a.component is not initial
  and a.qtyz025   is not initial

union

select distinct from ZCDS_PACK_MAT_DET   as a
  left outer join    I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                              and h.Plant   = a.plant
{
      //  key a.plant,
  key (case when h.SpecialProcurementType = '40' then '1100'
                  else a.plant end)          as Plant,
  key a.hedmaterial,
  key a.matZ027                              as component,
      //  case when a.qtyZ026 is not initial and a.qtyZ028 is not initial
      //       then cast( ( cast( ( a.qtyZ026 * a.qtyZ028 ) as abap.dec( 13, 3 ) ) * a.qtyz027 ) as abap.dec( 13, 3 ) )
      //       when a.qtyZ026 is not initial
      //       then cast( ( a.qtyZ026 * a.qtyz027 ) as abap.dec( 13, 3 ) )
      //       when a.qtyZ028 is not initial
      //       then cast( ( a.qtyZ028 * a.qtyz027 ) as abap.dec( 13, 3 ) )
      //       else cast( a.qtyz027 as abap.dec( 13, 3 ) ) end as qty,

      cast( a.qtyz027 as abap.dec( 13, 3 ) ) as qty

}
where
  a.qtyz027 is not initial


union

select distinct from ZCDS_PACK_MAT_DET   as a
  left outer join    I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                              and h.Plant   = a.plant
{
      //  key a.plant,
  key (case when h.SpecialProcurementType = '40' then '1100'
                  else a.plant end)          as Plant,
  key a.hedmaterial,
  key a.matZ026                              as component,
      //  case when a.qtyZ028 is not initial
      //       then cast( ( a.qtyZ028 * a.qtyZ026 ) as abap.dec( 13, 3 ) )
      //       else cast( a.qtyZ026 as abap.dec( 13, 3 ) ) end as qty
      cast( a.qtyZ026 as abap.dec( 13, 3 ) ) as qty

}
where
  a.qtyZ026 is not initial


union

select distinct from ZCDS_PACK_MAT_DET   as a
  left outer join    I_ProductPlantBasic as h on  h.Product = a.hedmaterial
                                              and h.Plant   = a.plant
{
      //  key a.plant,
  key (case when h.SpecialProcurementType = '40' then '1100'
                  else a.plant end)          as Plant,
  key a.hedmaterial,
  key a.matZ028                              as component,
      cast( a.qtyZ028 as abap.dec( 13, 3 ) ) as qty

}
where
  a.qtyZ028 is not initial
