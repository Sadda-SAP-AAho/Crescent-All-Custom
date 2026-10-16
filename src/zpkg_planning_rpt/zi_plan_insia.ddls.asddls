@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planning Report-INSIA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PLAN_INSIA
  as select distinct from ZR_PLAN_RPT_2_4
{
  key plant,
  key component                               as Crescent_Part_Code,
      cuscode                                 as CusCode,
      cusmat                                  as Foreign_Name_FG,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      NetWeight                               as Unit_Wt,
      WeightUnit,
      sum( cast( OpenContQty as abap.dec(15,3) ) +
      cast( OpenSoQty   as abap.dec(15,3) ) ) as Total_Order,
      castonhand                              as FG_On_Hand_Qty,
      stockZ028                               as Paint_On_Hand_Qty,
      stockZ027                               as Grinding_On_Hand_Qty,
      stockZ026                               as Machining_On_Hand_Qty,
      stockZ025                               as Casting_On_Hand_Qty

}

group by
  plant,
  component,
  cuscode,
  cusmat,
  WeightUnit,
  NetWeight,
  castonhand,
  stockZ028,
  stockZ027,
  stockZ026,
  stockZ025
