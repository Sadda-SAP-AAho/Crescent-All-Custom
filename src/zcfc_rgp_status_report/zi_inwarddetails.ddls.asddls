@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Inward Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_INWARDDETAILS
  as select distinct from zi_ghead            as a
    inner join            ZI_GITEM            as b on a.Id       =  b.Id
                                                   and(
                                                     a.Deleted   <> 'X'
                                                     or a.Cancel <> 'X'
                                                   )
    left outer join       I_BusinessUserBasic as c on a.Ernam = c.UserID
    left outer join       zi_ghead            as d on d.Gatepass =  a.rgpgatepass
                                                   and(
                                                     d.Deleted   <> 'X'
                                                     or d.Cancel <> 'X'
                                                   )
    left outer join       ZI_GITEM            as e on  d.Id       = e.Id
                                                   and b.gateitem = e.gateitem

{
  key a.Id,
  key b.Item,
  key b.gateitem       as GateItm,
      a.rgpgatepass,
      a.Gatepass       as ReturnGatePass,
      a.Gatepassdate   as ReturnGtPsDt,
      a.Challannumber  as ReturnChlnNo,
      a.Challandate    as ReturnChlnDt,
      a.Plantgateno    as ReturnPlant,
      a.Shipmenttype   as ReturnShipType,
      a.Vehno          as ReturnVehNo,
      c.PersonFullName as ReturnEmpNo,
      a.Vendorcode     as ReturnVendorCd,
      a.Vendorname     as ReturnVendorNam,
      a.Vehicleoutdate as ReturnVehOutDate,
      a.Type           as ReturnType,
      a.Fromplace      as ReturnFrm,
      a.Toplace        as ReturnTo,
      b.gateitem       as Returngateitem,
      b.Matnr          as ReturnMatnr,
      b.Maktx          as ReturnMaktx,
      b.Vendor         as ReturnVendor,
      b.Meins          as ReturnMeins,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.Challanqty     as ReturnChallanqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.Plantqty       as ReturnPlantqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.Orderqty       as ReutrnOrderqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.Balanceqty     as ReturnBalanceqty,
      @Semantics.quantity.unitOfMeasure: 'ReturnMeins'
      b.Deliverqty     as ReturnDeliverqty,
      b.Wtunit         as ReturnWtunit,
      @Semantics.quantity.unitOfMeasure : 'ReturnWtunit'
      b.netwt          as Returnnetwt,
      @Semantics.quantity.unitOfMeasure : 'ReturnWtunit'
      b.tarwt          as Returntarwt,
      @Semantics.quantity.unitOfMeasure : 'ReturnWtunit'
      b.grswt          as Returngrswt

}

where
      d.Type = 'RGP'
  and a.Type = 'RETURN RGP'
