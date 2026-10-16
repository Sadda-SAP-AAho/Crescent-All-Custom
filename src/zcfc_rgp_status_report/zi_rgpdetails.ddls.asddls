@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for RGP Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_RGPDETAILS
  as select distinct from ZI_OUTWARDDETAILS as a
    left outer join       ZI_INWARDDETAILS  as b on  a.Gatepass = b.rgpgatepass
                                                 and a.GateItm  = b.Returngateitem

{

  key a.Id,
  key a.Item,
  key a.GateItm,
      a.Gatepass,
      a.Gatepassdate,
      a.Challannumber,
      a.Challandate,
      a.Plantgateno,
      a.Shipmenttype,
      a.Vehno,
      a.Ernam,
      a.Vendorcode,
      a.Vendorname,
      a.Vehicleoutdate,
      a.Type,
      a.Fromplace,
      a.Toplace,
      a.sendername,
      a.Currency,
      a.Amount,
      a.gateitem,
      a.Matnr,
      a.Maktx,
      a.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Challanqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Plantqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.Orderqty,
      a.Wtunit,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      a.netwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      a.tarwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      a.grswt,
      a.Curr,
      a.Itemval1,
      ( case when b.ReturnGatePass <> '0000000000'
        then cast( b.ReturnGatePass as abap.char(10) )
        else cast( '' as abap.char(10) ) end ) as ReturnGatePass,
      ( case when b.ReturnGtPsDt <> '00000000'
            then cast( b.ReturnGtPsDt as abap.dats )
            else cast( '' as abap.dats ) end ) as ReturnGtPsDt,
      b.ReturnChlnNo,
      ( case when b.ReturnChlnDt <> '00000000'
            then cast( b.ReturnChlnDt as abap.dats )
            else cast( '' as abap.dats ) end ) as ReturnChlnDt,
      b.ReturnPlant,
      b.ReturnShipType,
      b.ReturnVehNo,
      b.ReturnEmpNo,
      b.ReturnVendorCd,
      b.ReturnVendorNam,
      b.ReturnVehOutDate,
      b.ReturnType,
      b.ReturnFrm,
      b.ReturnTo,
      b.Returngateitem,
      b.ReturnMatnr,
      b.ReturnMaktx,
      b.ReturnVendor,
      b.ReturnMeins,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.ReturnChallanqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.ReturnPlantqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.ReutrnOrderqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.ReturnBalanceqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.ReturnDeliverqty,
      b.ReturnWtunit,
      @Semantics.quantity.unitOfMeasure : 'ReturnWtunit'
      b.Returnnetwt,
      @Semantics.quantity.unitOfMeasure : 'ReturnWtunit'
      b.Returntarwt,
      @Semantics.quantity.unitOfMeasure : 'ReturnWtunit'
      b.Returngrswt

}
