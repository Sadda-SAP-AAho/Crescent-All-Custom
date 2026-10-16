@AbapCatalog.sqlViewName: 'ZTTLCASTQTYWT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Total Cast Qty and WT'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_TTLCASTQTYWT
  as select from ZI_RECEPTPRODLINE as a
{
  key a.RcptfrmPrdNo,
  key a.Item_Sl_No,
  key a.Id,
  key a.Refid,
      a.RcptfrmPrdDt,
      a.Opr_Code,
      a.Opr_Name,
      a.Dept_Code,
      a.Dept_Name,
      a.Cont_Code,
      a.Cont_Name,
      a.Plant_Code,
      a.Plant_Name,
      a.Mat_Code,
      a.Mat_Name,
      coalesce( a.Good_Cast_Qty,0 ) + coalesce( a.Rej_Qty,0 )                                                as Total_Cast_Qty,
      ( ( coalesce( a.Good_Cast_Qty,0 ) + coalesce( a.Rej_Qty,0 ) ) * cast( a.Std_Wt as abap.dec( 13, 3) ) ) as Total_Cast_Wt
}
