@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason Analysis-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_REJRESNREPORT
  as select distinct from ZI_REJRSNFL as a
    left outer join       I_Plant     as b on a.Plant = b.Plant
{
  key a.Shpflrno,
  key a.itemkey,
  key a.orderkey,
      a.Shpflrdt,
      a.Plant,
      b.PlantName,
      a.Dept,
      a.Deptname,
      a.Opr,
      a.Oprname,
      a.Cont,
      a.Contname,
      a.Matnr,
      a.Maktx,
      a.Profit_Center,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.UnitWt,
      a.Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Totcast,
      a.Meins,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.Total_Cast_Wt,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Goodcast,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.Total_Good_Cast_Wt,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Total_RejQty,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.Total_Rej_Wt,
      a.TOTAL_BEND,
      a.TOTAL_BLOW,
      a.TOTAL_CI_CAST,
      a.TOTAL_CHAPLET,
      a.TOTAL_COLDSHUT,
      a.TOTAL_CORESHIFT,
      a.TOTAL_CORNERDEFCT,
      a.TOTAL_CRACK,
      a.TOTAL_DEADSTOCK,
      a.TOTAL_DESCHNG,
      a.TOTAL_FLTPRBLM,
      a.TOTAL_INSERTSHIFT,
      a.TOTAL_EXTRAMETAL,
      a.TOTAL_FLANGEBROKEN,
      a.TOTAL_HARD,
      a.TOTAL_INTRNLDFCT,
      a.TOTAL_LESSWT,
      a.TOTAL_LDTSTFL,
      a.TOTAL_LOCKPRBLM

}
