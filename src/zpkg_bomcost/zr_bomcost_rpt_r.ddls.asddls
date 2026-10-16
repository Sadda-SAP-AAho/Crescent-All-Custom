@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Cost Report - Routing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BOMCOST_RPT_R
  as select from    zdt_bomdet                 as a
    inner join      I_MfgBOOMaterialAssignment as b on  b.Product = a.parent
                                                    and b.Plant   = a.plant
    inner join      I_Product                  as c on a.parent = c.Product
    left outer join I_ProductGroupText_2       as d on  d.ProductGroup = c.ProductGroup
                                                    and d.Language     = 'E'
{
  key a.plant                        as Plant,
  key a.hedmaterial                  as Hedmaterial,
      d.ProductGroup                 as HeaderGrpCode,
      d.ProductGroupName             as HeaderGrpName,
      '1'                            as HeadQty,
      a.bomlevel                     as Bomlevel,
      ( a.bomlevel - 1 )             as Bomlevel_p,
      a.parent                       as Parent,
      @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
      c.GrossWeight                  as ParentGrosswt,
      c.WeightUnit                   as ParentGrossWtUnit,
      @Semantics.quantity.unitOfMeasure: 'ParentNetWtUnit'
      c.NetWeight                    as ParentNetwt,
      c.WeightUnit                   as ParentNetWtUnit,
      'E'                            as Costitemcat,
      max( b.BillOfOperationsGroup ) as BillOfOperationsGroup,
      b.BillOfOperationsVariant
}
group by
  a.plant,
  a.hedmaterial,
  d.ProductGroup,
  d.ProductGroupName,
  a.bomlevel,
  a.parent,
  c.GrossWeight,
  c.WeightUnit,
  c.NetWeight,
  b.BillOfOperationsVariant
