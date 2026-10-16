@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass Head API'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_C_GHEAD_API_TP
  as select from Z_C_GHEAD_API
{

  key GateentryNo,
  key GateentryItem,
      Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      Netwt,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      Tarwt,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      Grswt,
      Wb1,
      ERNAM,
      ERZET,
      ERDAT,
      EBELN,
      EBELP,
      VBELN,
      POSNR,
      Plant,
      KUNNR,
      LIFNR,
      VECHILENO,
      GateDt,
      ChallanNo,
      ChallanDate,
      TRANSNAME,
      VESSELNAM,
      WBTRID,
      FROMPLACE,
      TOPLACE,
      PARTYNAME,
      Trans,
      MultiWeight,
      Noofweight,
      InDate,
      InTime,
      OutDate,
      OutTime,
      SlipNo,
      LRNo,
      LRDate,
      RakeNumber,
      MpNo,
      TpNo,
      Matnr,
      MatDesc,
      weighbentrydate,
      weighbentrytime,
      weighbexitdate,
      weighbexittime,
      ChallanQty
}
