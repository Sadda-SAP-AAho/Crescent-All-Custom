@AbapCatalog.sqlViewName: 'ZRECEPTPRODLINE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Rcpt from Prod-Line'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_RECEPTPRODLINE
  as select from ZI_RECEPTPRODHEAD a

{
  key a.RcptfrmPrdNo,
  key a.Item_Sl_No,
  key a.Id,
  key a.Refid,
      a.RcptfrmPrdDt,
      a.CreationDate,
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
      a.Profit_Center,
      a.typeofmould,
      a.Std_Wt,
      a.WeightUnit,
      a.Act_Wt,
      a.Qty_Box,
      a.Meins,
      sum( a.Box_Prod )                                                  as Box_Prod,
      sum( a.Good_Cast_Qty )                                             as Good_Cast_Qty,
      sum( a.Rej_Qty )                                                   as Rej_Qty,
      sum( a.Good_Cast_Qty ) * cast( a.Std_Wt as abap.dec( 13, 3) )      as Good_Cast_Wt,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      sum( a.Good_Cast_Qty ) * a.Act_Wt                                  as Act_Good_Cast_Wt,
      sum( a.Rej_Qty ) * cast( a.Std_Wt as abap.dec( 13, 3) )            as Rej_Wt,
      a.GrossWeight,
//      sum( a.Good_Cast_Qty ) * cast( a.GrossWeight as abap.dec( 13, 3) ) as Bunch_Wt,
      a.Shop_floor_No,
      a.Shop_floor_Dt

}
group by
  a.RcptfrmPrdNo,
  a.Item_Sl_No,
  a.Id,
  a.Refid,
  a.RcptfrmPrdDt,
  a.CreationDate,
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
  a.Profit_Center,
  a.typeofmould,
  a.Std_Wt,
  a.WeightUnit,
  a.Act_Wt,
  a.Qty_Box,
  a.Meins,
  a.GrossWeight,
  a.Shop_floor_No,
  a.Shop_floor_Dt
