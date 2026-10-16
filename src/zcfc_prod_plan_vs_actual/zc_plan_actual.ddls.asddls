@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Plan vs Actual'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_PLAN_ACTUAL
  as select from ZI_PLAN_ACTUAL
{
      @EndUserText.label: 'Type'
  key Type,
      @EndUserText.label: 'Plan Date'
      @Search.defaultSearchElement: true
  key plan_date,
      @EndUserText.label: 'Plant'
  key plant_code,
      @EndUserText.label: 'Material No'
  key mat_code,
      @EndUserText.label: 'Material Description'
      mat_name,
      @EndUserText.label: 'Material Group Code'
      ProductGroup,
      @EndUserText.label: 'Material Group Name'
      ProductGroupName,
      @EndUserText.label: 'Type of Mould'
      typeofmould,
      @UI.hidden: true
      WeightUnit,
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @EndUserText.label: 'Quanity per Box'
      QTB,
      @EndUserText.label: 'Plan Qty'
      plan_qty,
      @UI.hidden: true
      Meins,
      @EndUserText.label: 'Far Qty'
      far_qty,
      @EndUserText.label: 'Far Qty as per Box'
      far_qty_box,
      @EndUserText.label: 'Receipt from Prod. Qty'
      recpt_prod_qty,
      @EndUserText.label: 'Receipt from Prod. Qty as per Box'
      recpt_prod_qty_box,
      @EndUserText.label: 'MOC'
      MOC,
      @EndUserText.label: 'Total Plan Weight'
      ttl_plan_wt,
      @EndUserText.label: 'Total Far Weight'
      ttl_far_wt,
      @EndUserText.label: 'Total Production Weight'
      ttl_prod_wt
}
