@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Receipt from Production Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_RECPTPRODDATA
  as select from ZI_RECEPTPRODRPT as a
{
  key cast( a.RcptfrmPrdDt as abap.dats )                                                 as RcptfrmPrdDt,
  key a.Plant_Code,
  key a.Mat_Code,
  key concat( concat( cast( a.RcptfrmPrdDt as abap.dats ) , a.Plant_Code ) , a.Mat_Code ) as comb,
      sum( a.Good_Cast_Qty )                                                              as Goodcastqty
}

group by
  a.RcptfrmPrdDt,
  a.Plant_Code,
  a.Mat_Code
