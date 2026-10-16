@AbapCatalog.sqlViewName: 'ZREJRSNFINAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason Anlysis-Final'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_REJRSNFINAL
  as select from ZI_REJRSNHEAD   as a
    inner join   ZI_REJRSNBEND   as b on  a.RcptfrmPrdNo  = b.RcptfrmPrdNo
                                      and a.Item_Sl_No    = b.Item_Sl_No
                                      and a.Shop_floor_No = b.Shop_floor_No
                                      and a.Opr_Code      = b.Opr_Code
                                      and a.Dept_Code     = b.Dept_Code
                                      and a.Cont_Code     = b.Cont_Code
                                      and a.Plant_Code    = b.Plant_Code
                                      and a.Mat_Code      = b.Mat_Code

    inner join   ZI_REJRSNBLOW   as c on  a.RcptfrmPrdNo  = c.RcptfrmPrdNo
                                      and a.Item_Sl_No    = c.Item_Sl_No
                                      and a.Shop_floor_No = c.Shop_floor_No
                                      and a.Opr_Code      = c.Opr_Code
                                      and a.Dept_Code     = c.Dept_Code
                                      and a.Cont_Code     = c.Cont_Code
                                      and a.Plant_Code    = c.Plant_Code
                                      and a.Mat_Code      = c.Mat_Code

    inner join   ZI_REJRSNCICAST as d on  a.RcptfrmPrdNo  = d.RcptfrmPrdNo
                                      and a.Item_Sl_No    = d.Item_Sl_No
                                      and a.Shop_floor_No = d.Shop_floor_No
                                      and a.Opr_Code      = d.Opr_Code
                                      and a.Dept_Code     = d.Dept_Code
                                      and a.Cont_Code     = d.Cont_Code
                                      and a.Plant_Code    = d.Plant_Code
                                      and a.Mat_Code      = d.Mat_Code

    inner join   ZI_REJRSNCHPLT  as e on  a.RcptfrmPrdNo  = e.RcptfrmPrdNo
                                      and a.Item_Sl_No    = e.Item_Sl_No
                                      and a.Shop_floor_No = e.Shop_floor_No
                                      and a.Opr_Code      = e.Opr_Code
                                      and a.Dept_Code     = e.Dept_Code
                                      and a.Cont_Code     = e.Cont_Code
                                      and a.Plant_Code    = e.Plant_Code
                                      and a.Mat_Code      = e.Mat_Code

    inner join   ZI_REJRSNCLDSHT as f on  a.RcptfrmPrdNo  = f.RcptfrmPrdNo
                                      and a.Item_Sl_No    = f.Item_Sl_No
                                      and a.Shop_floor_No = f.Shop_floor_No
                                      and a.Opr_Code      = f.Opr_Code
                                      and a.Dept_Code     = f.Dept_Code
                                      and a.Cont_Code     = f.Cont_Code
                                      and a.Plant_Code    = f.Plant_Code
                                      and a.Mat_Code      = f.Mat_Code
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
      a.Rej_Wt,
      
      cast( ( coalesce( b.Total_Qty1_Bend,0 ) + coalesce( b.Total_Qty2_Bend,0 ) + coalesce( b.Total_Qty3_Bend,0 ) +
      coalesce( b.Total_Qty4_Bend,0 ) + coalesce( b.Total_Qty5_Bend,0 ) + coalesce( b.Total_Qty6_Bend,0 ) +
      coalesce( b.Total_Qty7_Bend,0 ) + coalesce( b.Total_Qty8_Bend,0 ) + coalesce( b.Total_Qty9_Bend,0 ) ) as abap.dec( 13, 3) ) as TOTAL_BEND,
      
      cast( ( coalesce( c.Total_Qty1_Blow,0 ) + coalesce( c.Total_Qty2_Blow,0 ) + coalesce( c.Total_Qty3_Blow,0 ) +
      coalesce( c.Total_Qty4_Blow,0 ) + coalesce( c.Total_Qty5_Blow,0 ) + coalesce( c.Total_Qty6_Blow,0 ) +
      coalesce( c.Total_Qty7_Blow,0 ) + coalesce( c.Total_Qty8_Blow,0 ) + coalesce( c.Total_Qty9_Blow,0 ) ) as abap.dec( 13, 3) ) as TOTAL_BLOW,
      
      cast( ( coalesce( d.Total_Qty1_CICast,0 ) + coalesce( d.Total_Qty2_CICast,0 ) + coalesce( d.Total_Qty3_CICast,0 ) +
      coalesce( d.Total_Qty4_CICast,0 ) + coalesce( d.Total_Qty5_CICast,0 ) + coalesce( d.Total_Qty6_CICast,0 ) +
      coalesce( d.Total_Qty7_CICast,0 ) + coalesce( d.Total_Qty8_CICast,0 ) + coalesce( d.Total_Qty9_CICast,0 ) ) as abap.dec( 13, 3) ) as TOTAL_CI_CAST
}
