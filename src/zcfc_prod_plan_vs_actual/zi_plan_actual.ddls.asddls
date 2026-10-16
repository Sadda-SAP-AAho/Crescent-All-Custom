@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Plan vs Actual'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PLAN_ACTUAL
  as select distinct from ZI_PLAN_ACTUAL_1     as a
    inner join            I_Product            as b on a.mat_code = b.Product
    inner join            I_ProductGroupText_2 as c on b.ProductGroup = c.ProductGroup

{
  key a.Type,
  key a.plan_date,
  key a.plant_code,
  key a.mat_code,
      a.mat_name,
      b.ProductGroup,
      c.ProductGroupName,
      a.typeofmould,
      a.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight,
      a.QTB,
      a.plan_qty,
      a.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.far_qty,
      a.far_qty_box,
      a.recpt_prod_qty,
      a.recpt_prod_qty_box,
      a.MOC,
      a.ttl_plan_wt,
      a.ttl_far_wt,
      a.ttl_prod_wt

}

where
  a.Status = 'Y'

union all

select distinct from ZI_PLAN_ACTUAL_2     as a
  inner join         I_Product            as b on a.mat_code = b.Product
  inner join         I_ProductGroupText_2 as c on b.ProductGroup = c.ProductGroup

{
  key a.Type,
  key a.plan_date,
  key a.plant_code,
  key a.mat_code,
      a.mat_name,
      b.ProductGroup,
      c.ProductGroupName,
      a.typeofmould,
      a.WeightUnit,
      a.NetWeight,
      a.QTB,
      a.plan_qty,
      a.Meins,
      a.far_qty,
      a.far_qty_box,
      a.recpt_prod_qty,
      a.recpt_prod_qty_box,
      a.MOC,
      a.ttl_plan_wt,
      a.ttl_far_wt,
      a.ttl_prod_wt
}

where
  a.Status = 'Y'
  
  union all

select distinct from ZI_PLAN_ACTUAL_3     as a
  inner join         I_Product            as b on a.mat_code = b.Product
  inner join         I_ProductGroupText_2 as c on b.ProductGroup = c.ProductGroup

{
  key a.Type,
  key a.plan_date,
  key a.plant_code,
  key a.mat_code,
      a.mat_name,
      b.ProductGroup,
      c.ProductGroupName,
      a.typeofmould,
      a.WeightUnit,
      a.NetWeight,
      a.QTB,
      a.plan_qty,
      a.Meins,
      a.far_qty,
      a.far_qty_box,
      a.recpt_prod_qty,
      a.recpt_prod_qty_box,
      a.MOC,
      a.ttl_plan_wt,
      a.ttl_far_wt,
      a.ttl_prod_wt
}

where
  a.Status = 'Y'
  
