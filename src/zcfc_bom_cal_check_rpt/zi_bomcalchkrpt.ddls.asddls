@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Calculation Check Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_BOMCALCHKRPT
  as select distinct from ZR_BOMCOST_RPT       as a

    left outer join       I_ProductText        as b on  a.Hedmaterial = b.Product
                                                    and b.Language    = 'E'

    left outer join       zdt_pp_matinffld     as c on a.Hedmaterial = c.product

    left outer join       zdt_pp_matinffld     as d on a.Component = d.product

    left outer join       ZI_PAINTBOMMSTR      as e on  a.Component = e.Paintitmcd
                                                    and c.micr      = e.Micron

    left outer join       I_Product            as f on f.Product = a.Component

    left outer join       I_ProductGroupText_2 as g on f.ProductGroup = g.ProductGroup


{
  key a.Plant,
  key a.HeaderGrpCode                                               as ProductGroup,
  key a.Hedmaterial                                                 as HeadMatlCode,
  key b.ProductName                                                 as HeadMatlName,
  key a.HeadQty                                                     as HeaderQty,
  key c.sqmtr,
  key a.Component                                                   as ComponentCode,
      a.ChildDesc                                                   as ComponentName,
      f.ProductGroup                                                as CompGrpCode,
      g.ProductGroupName                                            as CompGrpName,
      c.micr                                                        as Micron,
      e.Submicron                                                   as SubMicron,
      e.Stdqty                                                      as StdQty,
      cast( ( c.sqmtr * e.Stdqty ) as abap.dec(13,3) )              as BOMQtyCal,
      a.Childqty                                                    as BOMQtySAP,
      a.Childqty - cast( ( c.sqmtr * e.Stdqty ) as abap.dec(13,3) ) as Difference

}

where
       cast( a.Bomlevel as abap.int4 ) = 1

  and(
       f.ProductGroup                  = 'Z020'
    or f.ProductGroup                  = 'Z039'
  )
