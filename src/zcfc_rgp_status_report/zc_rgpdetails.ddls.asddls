@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for RGP Details'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_RGPDETAILS
  provider contract transactional_query
  as projection on ZI_RGPDETAILS

{

      @UI.hidden: true
  key Id,
      @UI.hidden: true
  key Item,
      @UI.hidden: true
  key GateItm,
      @EndUserText.label: 'RGP Gate Pass No'
      @Search.defaultSearchElement: true
      Gatepass,
      @EndUserText.label: 'RGP Gate Pass Date'
      Gatepassdate,
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
      @EndUserText.label: 'Employee Name'
      Ernam,
      @EndUserText.label: 'Supplier Code'
      Vendorcode,
      @EndUserText.label: 'Supplier Name'
      Vendorname,
      @EndUserText.label: 'Vehicle Out Date'
      Vehicleoutdate,
      @EndUserText.label: 'Type'
      Type,
      @EndUserText.label: 'Form'
      Fromplace,
      @EndUserText.label: 'To'
      Toplace,
      @EndUserText.label: 'Sender Name'
      sendername,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Value'
      Amount,
      @EndUserText.label: 'Material Sl No'
      gateitem,
      @EndUserText.label: 'Material Code'
      Matnr,
      @EndUserText.label: 'Material Name'
      Maktx,
      @UI.hidden: true
      Meins,
      @EndUserText.label: 'Challan Qty'
      Challanqty,
      @EndUserText.label: 'Plant Qty'
      Plantqty,
      @EndUserText.label: 'Order Qty'
      Orderqty,
      @UI.hidden: true
      Wtunit,
      @EndUserText.label: 'Net Wt'
      netwt,
      @EndUserText.label: 'Tare Wt'
      tarwt,
      @EndUserText.label: 'Gross Wt'
      grswt,
      @EndUserText.label: 'Currency'
      Curr,
      @EndUserText.label: 'Value'
      Itemval1,
      @EndUserText.label: 'Return Gate Pass No'
      ReturnGatePass,
      @EndUserText.label: 'Return Gate Pass Date'
      ReturnGtPsDt,
      @EndUserText.label: 'Return Challan No'
      ReturnChlnNo,
      @EndUserText.label: 'Return Challan Date'
      ReturnChlnDt,
      @EndUserText.label: 'Plant'
      ReturnPlant,
      @EndUserText.label: 'Transport Type'
      ReturnShipType,
      @EndUserText.label: 'Vehicle No'
      ReturnVehNo,
      @EndUserText.label: 'Emp No.'
      ReturnEmpNo,
      @EndUserText.label: 'Supplier Code'
      ReturnVendorCd,
      @EndUserText.label: 'Supplier Name'
      ReturnVendorNam,
      @EndUserText.label: 'Vehicle Out Date'
      ReturnVehOutDate,
      @EndUserText.label: 'Return Type'
      ReturnType,
      @EndUserText.label: 'Form'
      ReturnFrm,
      @EndUserText.label: 'To'
      ReturnTo,
      @EndUserText.label: 'Material Sl No'
      Returngateitem,
      @EndUserText.label: 'Material Code'
      ReturnMatnr,
      @EndUserText.label: 'Material Name'
      ReturnMaktx,
      @EndUserText.label: 'Supplier'
      ReturnVendor,
      @UI.hidden: true
      ReturnMeins,
      @EndUserText.label: 'Challan Qty'
      ReturnChallanqty,
      @EndUserText.label: 'Plant Qty'
      ReturnPlantqty,
      @EndUserText.label: 'Order Qty'
      ReutrnOrderqty,
      @EndUserText.label: 'Balance Qty'
      ReturnBalanceqty,
      @EndUserText.label: 'Delivered Qty'
      ReturnDeliverqty,
      @UI.hidden: true
      ReturnWtunit,
      @EndUserText.label: 'Net Wt'
      Returnnetwt,
      @EndUserText.label: 'Tare Wt'
      Returntarwt,
      @EndUserText.label: 'Gross Wt'
      Returngrswt
      
}
