@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Info'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATERIAL_INFO
  as select distinct from I_Product            as a
    inner join            I_ProductText        as b on  a.Product  = b.Product
                                                    and b.Language = 'E'
    left outer join       I_ProductGroupText_2 as q on a.ProductGroup = q.ProductGroup
    left outer join       I_UnitOfMeasure      as c on a.BaseUnit = c.UnitOfMeasure
    left outer join       zdt_pp_matinffld     as f on a.Product = f.product
    left outer join       I_ProductTypeText_2  as t on  a.ProductType = t.ProductType
                                                    and t.Language    = 'E'
    left outer join       I_ProductPlantBasic  as d on a.Product = d.Product
    left outer join       I_Plant              as g on  d.Plant    = g.Plant
                                                    and q.Language = 'E'

{
  key a.Product          as MaterialNo,
  key d.Plant            as PlantCode,
      b.ProductName      as Description,
      a.ProductType      as ProductType,
      t.ProductTypeName  as ProductTypName,
      a.ProductGroup     as MaterialGroup,
      q.ProductGroupName as MaterialGroupName,
      c.UnitOfMeasure_E  as UoM,
      a.WeightUnit       as WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.GrossWeight      as GrossWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight        as NetWeight,
      a.WeightUnit       as UnitofWeight,
      f.qtyperbox        as QtyPerBox,
      f.moc              as MOC
}
where
  a.CrossPlantStatus <> '05'
