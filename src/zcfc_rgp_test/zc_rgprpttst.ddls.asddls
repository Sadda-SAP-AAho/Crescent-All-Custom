@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP IN and OUT Report Test'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_RGPRPTTST
  provider contract transactional_query
  as projection on ZI_RGPRPTTST
{
     
      @Search.defaultSearchElement: true
      @UI.hidden: true
  key Id,
  @EndUserText.label: 'RGP Challan No'
      Challannumber,
      @EndUserText.label: 'RGP Challan Date'
      Challandate,
      @EndUserText.label: 'Plant'
      Plantgateno,
      @EndUserText.label: 'Transport Type'
      Shipmenttype,
      @EndUserText.label: 'Vehicle No'
      Vehno,
      @EndUserText.label: 'Emp No.'
      Ernam,
      @EndUserText.label: 'Supplier Code'
      Vendorcode,
      @EndUserText.label: 'Supplier Name'
      Vendorname,
      @EndUserText.label: 'RGP Gate Pass No'
      Gatepass,
      @EndUserText.label: 'RGP Gate Pass Dt'
      Gatepassdate,
      @EndUserText.label: 'Vehicle Out Dt'
      Vehicleoutdate,
      @EndUserText.label: 'Type'
      Type,
      @EndUserText.label: 'Form'
      Fromplace,
      @EndUserText.label: 'To'
      Toplace,
      @EndUserText.label: 'Sender Name'
      sendername,
      @EndUserText.label: 'Value'
      Amountt,
      @EndUserText.label: 'Material Code'
      matnr,
      @EndUserText.label: 'Material Name'
      maktx,
       @UI.hidden: true
      meins,
      @EndUserText.label: 'Challan Qty'
      challanqty,
      @EndUserText.label: 'Plant Qty'
      plantqty,
      @EndUserText.label: 'Order Qty'
      orderqty,
      @EndUserText.label: 'Balance Qty'
      balanceqty,
      @EndUserText.label: 'Delivered Qty'
      deliverqty,
      @EndUserText.label: 'Material Sl No'
      gateitem,
      @EndUserText.label: 'Net Wt'
      netwt,
      @EndUserText.label: 'Tare Wt'
      tarwt,
      @EndUserText.label: 'Gross Wt'
      grswt,
      @EndUserText.label: 'Wt UoM'
      wtunit,
      @EndUserText.label: 'Currency'
      currency,
      @EndUserText.label: 'Value'
      itemval1,
      @EndUserText.label: 'Return Challan No'
      ChlnNo,
      @EndUserText.label: 'Return Challan Dt'
      ChlnDt,
      @EndUserText.label: 'Plant'
      PltGtNo,
      @EndUserText.label: 'Transport Type'
      ShpTyp,
      @EndUserText.label: 'Vehicle No'
      VNo,
      @EndUserText.label: 'Emp No.'
      Erm,
      @EndUserText.label: 'Supplier Code'
      VenCode,
      @EndUserText.label: 'Supplier Name'
      VName,
      @EndUserText.label: 'Return Gate Pass No'
      GPass,
      @EndUserText.label: 'Return Gate Pass Dt'
      GaPaDt,
      @EndUserText.label: 'Vehicle Out Dt'
      VOD,
      @EndUserText.label: 'Type'
      Typ,
      @EndUserText.label: 'Form'
      FrmPlc,
      @EndUserText.label: 'To'
      ToPlc,
      @EndUserText.label: 'RGP Gate Pass No'
      rgpgatepass,
      @EndUserText.label: 'GATEPASS'
      GtPass,
      @EndUserText.label: 'Material Code'
      MtNr,
      @EndUserText.label: 'Material Name'
      MkTx,
      @EndUserText.label: 'Supplier'
      vendor,
      @EndUserText.label: 'Challan Qty'
      ChllnQty,
      @EndUserText.label: 'Plant Qty'
      PltQty,
      @EndUserText.label: 'Order Qty'
      OrdQty,
      @EndUserText.label: 'Balance Qty'
      BalQty,
      @EndUserText.label: 'Delivered Qty'
      DelQty,
      @EndUserText.label: 'Material Sl No'
      GItem,
      @EndUserText.label: 'Net Wt'
      NtWt,
      @EndUserText.label: 'Tare Wt'
      TWt,
      @EndUserText.label: 'Gross Wt'
      GrWt,
      @EndUserText.label: 'Wt UoM'
      WUt
}
