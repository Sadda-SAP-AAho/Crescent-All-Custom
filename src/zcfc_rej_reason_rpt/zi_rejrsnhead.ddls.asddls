@AbapCatalog.sqlViewName: 'ZREJRSNHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason Header'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRSNHEAD
  as select distinct from ZI_RECEPTPRODRPT as a
{
  key a.RcptfrmPrdNo,
  key a.RcptfrmPrdDt,
  key a.Item_Sl_No,
  key a.Refid,
  key a.Shop_floor_No,
  key a.Shop_floor_Dt,
  key a.Opr_Code,
  key a.Opr_Name,
  key a.Dept_Code,
  key a.Dept_Name,
  key a.Cont_Code,
  key a.Cont_Name,
  key a.Plant_Code,
  key a.Plant_Name,
  key a.Mat_Code,
      a.Mat_Name,
      a.Profit_Center,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.Std_Wt,
      a.WeightUnit,
      a.Total_Cast_Qty,
      a.Total_Cast_Wt,
      a.Good_Cast_Qty,
      a.Good_Cast_Wt,
      a.Rej_Qty,
      a.Rej_Wt

}
