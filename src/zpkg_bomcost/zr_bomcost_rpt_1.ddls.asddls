@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Cost Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BOMCOST_RPT_1
  as select distinct from zdt_bomdet              as a
    inner join            I_ProductDescription    as b on  a.component = b.Product
                                                       and b.Language  = 'E'
    inner join            I_Product               as c on a.component = c.Product
    inner join            I_ProductValuationBasic as d on  a.component = d.Product
                                                       and a.plant     = d.ValuationArea
    inner join            I_Product               as e on a.parent = e.Product
    inner join            I_Product               as x on a.hedmaterial = x.Product
    left outer join       I_ProductGroupText_2    as f on  f.ProductGroup = c.ProductGroup
                                                       and f.Language     = 'E'
    left outer join       I_ProductGroupText_2    as g on  g.ProductGroup = x.ProductGroup
                                                       and g.Language     = 'E'
    left outer join       ZR_CHILDSTOCK           as h on  h.Product = c.Product
                                                       and h.Plant   = a.plant
    left outer join       ZI_BOM_COMP_DETAILS     as i on  a.parent    = i.Material
                                                       and a.plant     = i.plant
                                                       and a.component = i.BillOfMaterialComponent
    left outer join       ZTBL_FCTN_BOMITEM       as j on  i.BillOfMaterialComponent = j.material
                                                       and i.plant                   = j.plant


{
  key a.plant                                                                                                          as Plant,
  key a.hedmaterial                                                                                                    as Hedmaterial,
      g.ProductGroup                                                                                                   as HeaderGrpCode,
      g.ProductGroupName                                                                                               as HeaderGrpName,
      '1'                                                                                                              as HeadQty,
      a.bomlevel                                                                                                       as Bomlevel,
      a.parent                                                                                                         as Parent,
      
      @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
      e.GrossWeight                                                                                                    as ParentGrosswt,
      e.WeightUnit                                                                                                     as ParentGrossWtUnit,
      @Semantics.quantity.unitOfMeasure: 'ParentNetWtUnit'
      e.NetWeight                                                                                                      as ParentNetwt,
      e.WeightUnit                                                                                                     as ParentNetWtUnit,

      'M'                                                                                                              as Costitemcat,
      a.component                                                                                                      as Component,
      b.ProductDescription                                                                                             as ChildDesc,

      f.ProductGroup                                                                                                   as ChildGrpCode,
      f.ProductGroupName                                                                                               as ChildGrpName,
      ( case when ( i.BillOfMaterialComponent = j.material and i.plant = j.plant) then i.StorageLocation else '' end ) as ChildStorageLoc,
      case when a.parentqty is not initial
               then  division(a.childqty,a.parentqty,3)
                else null end                                                                                          as Childqty,
      a.bomitemqtyunit                                                                                                 as Bomitemqtyunit,
      @Semantics.quantity.unitOfMeasure: 'ChildWtUnit'
      c.NetWeight                                                                                                      as ChildNetwt,
      c.WeightUnit                                                                                                     as ChildWtUnit,
      h.Plant                                                                                                          as ChildPlant,
      h.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      h.MatlStock                                                                                                      as ChildMatlStock,
      d.InventoryValuationProcedure                                                                                    as PriceControl,
      d.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      case d.InventoryValuationProcedure
      when 'S' then case when ( c.ProductGroup = 'Z021' and c.ExternalProductGroup = 'ZE02' ) then d.StandardPrice else null end
      when 'V' then d.MovingAveragePrice else null end                                                                 as Rate,
      case when  d.PriceUnitQty is initial then 1
           else d.PriceUnitQty end                                                                                     as RateQty

}
