@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Planning Rpt 2_1'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZR_PLAN_RPT_2_1
  //    as select from ZR_PLAN_RPT_2 as a
  as select from ZR_PLAN_RPT_2_5_1 as a

{
  key a.plant,
      //        key a.hedmaterial,
  key a.component,

      a.ProductGroup,
      a.ProductDescription,
      a.WeightUnit,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight,

      a.ProfitCenter,
      a.ProfitCenterLongName,
      a.cuscode,
      a.qtyperbox,
      a.prodcapcday,
      a.boxsize,
      a.typemould,
      a.OpenContQty,
      a.OpenSoQtyRem,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      cast((cast(a.OpenContQty as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenContQtyWt,

      //      ( a.OpenContQty * a.NetWeight )                                                         as OpenContQtyWt,
      a.OpenSoQty,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      cast((cast(a.OpenSoQty as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))    as OpenSoQtyWt,

      //      ( a.OpenSoQty * a.NetWeight )                                                           as OpenSoQtyWt,
      a.castonhand,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      cast((cast(a.castonhand as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))   as castonhandWt,

      a.FgLiveQty,

      cast(cast(a.FgLiveQty as abap.dec(13,3)) *
           cast(a.NetWeight as abap.dec(13,3))  as abap.dec(31,3))                   as FgLivewt,

      case when coalesce(a.OpenSoQty,0) < a.castonhand
             then  cast((coalesce(a.castonhand,0) - coalesce(a.OpenSoQty,0) ) as abap.dec(21,3))
             else null end                                                           as FgdeadQty,

      case when   coalesce(a.OpenSoQty,0) < a.castonhand
             then  ( cast((coalesce(a.castonhand,0) - coalesce(a.OpenSoQty,0) ) as abap.dec(21,3)) *
                     cast(a.NetWeight as abap.dec(13,3))
                    ) else null end                                                  as FgdeadWt,

      //      cast(case when a.FgLiveQty is null
      //           then(cast((a.OpenSoQty - a.castonhand) as abap.dec(13,3)) *
      //                cast(a.NetWeight as abap.dec(13,3))
      //               ) else null end  as abap.dec(31,3))                                   as FgdeadWt,

      a.stockZ028,
      a.stockZ026,
      a.stockZ027,
      a.stockZ045,
      a.stockZ025,
      a.stockZ024,

      cast((coalesce(cast(a.stockZ028 as abap.dec(23,3)), 0) +
               coalesce(cast(a.stockZ026 as abap.dec(23,3)), 0) +
               coalesce(cast(a.stockZ027 as abap.dec(23,3)), 0) +
               coalesce(cast(a.stockZ045 as abap.dec(23,3)), 0) +
               coalesce(cast(a.stockZ025 as abap.dec(23,3)), 0) +
               coalesce(cast(a.stockZ024 as abap.dec(23,3)), 0)
             ) as abap.dec(31,3))                                                    as SfgOnHand,

      cast(((coalesce(cast(a.stockZ028 as abap.dec(13,3)), 0) +
             coalesce(cast(a.stockZ026 as abap.dec(13,3)), 0) +
             coalesce(cast(a.stockZ027 as abap.dec(13,3)), 0) +
             coalesce(cast(a.stockZ045 as abap.dec(13,3)), 0) +
             coalesce(cast(a.stockZ025 as abap.dec(13,3)), 0) +
             coalesce(cast(a.stockZ024 as abap.dec(13,3)), 0)
            ) * cast(a.NetWeight as abap.dec(13,3))) as abap.dec(31,3))              as SfgOnHandWt,

      a.OpenSoQty7,
      cast((cast(a.OpenSoQty7 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))   as OpenSoQty7Wt,
      a.OpenSoQty8,
      cast((cast(a.OpenSoQty8 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))   as OpenSoQty8Wt,
      a.OpenSoQty16,
      cast((cast(a.OpenSoQty16 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty16Wt,
      a.OpenSoQty23,
      cast((cast(a.OpenSoQty23 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty23Wt,
      a.OpenSoQty31,
      cast((cast(a.OpenSoQty31 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty31Wt,
      a.OpenSoQty39,
      cast((cast(a.OpenSoQty39 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty39Wt,
      a.OpenSoQty47,
      cast((cast(a.OpenSoQty47 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty47Wt,
      a.OpenSoQty55,
      cast((cast(a.OpenSoQty55 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty55Wt,
      a.OpenSoQty63,
      cast((cast(a.OpenSoQty63 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty63Wt,
      a.OpenSoQty71,
      cast((cast(a.OpenSoQty71 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3))  as OpenSoQty71Wt,
      a.OpenSoQty366,
      cast((cast(a.OpenSoQty366 as abap.dec(13,3)) * a.NetWeight) as abap.dec(31,3)) as OpenSoQty366Wt
}
