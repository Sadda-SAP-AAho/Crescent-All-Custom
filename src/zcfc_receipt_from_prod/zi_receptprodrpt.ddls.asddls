@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Receipt from Production-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_RECEPTPRODRPT
  as select distinct from ZI_RECEPTPRODLINE as a
    inner join            ZI_TTLCASTQTYWT   as b on  a.RcptfrmPrdNo = b.RcptfrmPrdNo
                                                 and a.Item_Sl_No   = b.Item_Sl_No
                                                 and a.Refid        = b.Refid
                                                 and a.Id           = b.Id
                                                 and a.Plant_Code   = b.Plant_Code
                                                 and a.Mat_Code     = b.Mat_Code
{
  key a.RcptfrmPrdNo,
  key a.Item_Sl_No,
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
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.Std_Wt,
      a.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.Act_Wt,
      a.Qty_Box,
      a.Meins,
      a.Box_Prod,
      b.Total_Cast_Qty,
      a.Good_Cast_Qty,
      a.Rej_Qty,
      b.Total_Cast_Wt,
      a.Good_Cast_Wt,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.Act_Good_Cast_Wt,
      a.Rej_Wt,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.GrossWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      //      a.Bunch_Wt,
      ( case when ( a.Qty_Box is null or a.Qty_Box = 0 )
      then ( cast( div ( b.Total_Cast_Qty, 1 ) as abap.dec( 16, 3 ) ) ) * ( cast( a.GrossWeight as abap.dec( 13, 3 ) ) )
      else ( cast( div ( b.Total_Cast_Qty, a.Qty_Box ) as abap.dec( 16, 3 ) ) ) * ( cast( a.GrossWeight as abap.dec( 13, 3 ) ) ) end ) as Bunch_Wt,
      a.Shop_floor_No,
      a.Shop_floor_Dt                                                                                                                  as Shop_floor_Dt
}
