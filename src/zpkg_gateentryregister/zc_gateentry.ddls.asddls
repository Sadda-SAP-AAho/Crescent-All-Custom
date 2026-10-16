@AbapCatalog.sqlViewName: 'ZCGATEENTRY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gateentry register consumption view'
@Metadata.allowExtensions: true
define view zc_gateentry
  as select from ZI_GATEENTRY
{
      @UI.hidden: true
  key Id,
      @UI.hidden: true
  key Item,
      @EndUserText.label: 'Challan No'
      Challannumber,
      @EndUserText.label: 'Challan Date'
      Challandate,
      @EndUserText.label: 'Status'
      status,
      @EndUserText.label: 'Criticality'
      Criticality,
      @EndUserText.label: 'Progress'
      Progress,
      @EndUserText.label: 'RR No.'
      Rrno,
      @EndUserText.label: 'RR Date.'
      Rrdate,
      @EndUserText.label: 'LR/BL NO.'
      Lrblno,
      @EndUserText.label: 'LR/BL Date.'
      Lbbldate,
      @EndUserText.label: 'Bill Of Entry No.'
      Billofentryno,
      @EndUserText.label: 'Bill Of Entry Date.'
      Billofentrydate,
      @UI.hidden: true
      Miningpermissionno,
      @EndUserText.label: 'Way Bill No.'
      Waybillno,
      @EndUserText.label: 'MP No'
      MiningchallanMpno,
      @EndUserText.label: 'TP No'
      Miningchallantpno,
      @EndUserText.label: 'Plant Gate No'
      Plantgateno,
      @EndUserText.label: 'Plant WeighBridge No'
      Plantweighbridgeno,
      @EndUserText.label: 'Mode Of Transport'
      Shipmenttype,
      @EndUserText.label: 'Vehicle No.'
      Vehno,
      @UI.hidden: true
      ContainerNumber,
      @UI.hidden: true
      Vesselname,
      @UI.hidden: true
      Rakeno,
      @UI.hidden: true
      Raketripno,
      @EndUserText.label: 'Created By'
      Ernam,
      @UI.hidden: true
      Erdat,
      @UI.hidden: true
      Erzet,
      @EndUserText.label: 'Gateentry Date'
      Gateentrydate,
      @EndUserText.label: 'Gateentry Time'
      Gateentrytime,
      @EndUserText.label: 'Vendor Code'
      Vendorcode,
      @EndUserText.label: 'Vendor Name'
      Vendorname,
      @EndUserText.label: 'Customer Code'
      Customercode,
      @EndUserText.label: 'Customer Name'
      Customername,
      @UI.hidden: true
      Drivername,
      @UI.hidden: true
      Drivercellno,
      @UI.hidden: true
      Dlno,
      @UI.hidden: true
      Vehiclecheck,
      @EndUserText.label: 'Test Cerificate'
      Testcertificate,
      Taxinvoice,
      @EndUserText.label:'Transporter code'
      Transportercode,
      @EndUserText.label: 'Transporter Name'
      Transportername,
      @EndUserText.label: 'Invoice number'
      Invoice,
      @UI.hidden: true
      Invoicedate,
      @UI.hidden: true
      Remarks,
      @EndUserText.label: 'Gatepass No'
      Gatepass,
      @UI.hidden: true
      Gatepassdate,
      Purchasingdocumentnumber,
      @EndUserText.label: 'Vehicle Out Date'
      Vehicleoutdate,
      @EndUserText.label: 'Vehicle Out Time'
      Vehicleouttime,
      @UI.hidden: true
      Unloaddate,
      @UI.hidden: true
      Unloadtime,
      @UI.hidden: true
      Gateout,
      @UI.hidden: true
      Deleted,
      @UI.hidden: true
      Cancel,
      @UI.hidden: true
      Miscnumber,
      @UI.hidden: true
      Miscdate,
      @UI.hidden: true
      Currentyear,
      @UI.hidden: true
      Currentnumber,
      @UI.hidden: true
      Bukrs,
      @UI.hidden: true
      Plant,
      @UI.hidden: true
      Type,
      @EndUserText.label: 'UOM'
      Meins,
      @UI.hidden: true
      Netwt,
      @UI.hidden: true
      Tarwt,
      @UI.hidden: true
      Grswt,
      @UI.hidden: true
      Deleteuser,
      @UI.hidden: true
      Deletedate,
      //      @EndUserText.label: 'Status'
      //      Status,
      //      @UI.hidden: true
      //      Criticality,
      @UI.hidden: true
      Printr,
      @EndUserText.label: 'PO No/SO No'
      Ebeln,
      @EndUserText.label: 'Item No.'
      Ebelp,
      @EndUserText.label: 'Delivery'
      Vbeln,
      Vbelp,
      @EndUserText.label: 'Material Code'
      Matnr,
      @EndUserText.label: 'Material Description'
      Maktx,
      @UI.hidden: true
      Posnr,
      @UI.hidden: true
      VbelnVf,
      @UI.hidden: true
      PosnrVf,
      @UI.hidden: true
      Mblnr,
      @UI.hidden: true
      Mjahr,
      @UI.hidden: true
      Zeile,
      @EndUserText.label: 'Challan Qty'
      Challanqty,
      @UI.hidden: true
      Orderqty,
      @UI.hidden: true
      Totalqty,
      @UI.hidden: true
      Balanceqty,
      @UI.hidden: true
      Deliverqty
}
