@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'GatePass Header'

define root view entity ZC_GHEAD
  provider contract transactional_query
  as projection on zi_ghead
{
          @EndUserText.label: 'ID'
  key     Id,
          @EndUserText.label: 'Challan / Invoice Number'
          Challannumber,
          @EndUserText.label: 'Challan / Invoice Date'
          Challandate,
          @UI.hidden: true
          Total,
          @EndUserText.label: 'Progress Bar'
          Progress,
          @EndUserText.label: 'Status'
          Status,
          @EndUserText.label: 'Criticality'
          Criticality,
          //          @EndUserText.label: 'RR No.'
          //          @UI.hidden: true
          //          Rrno,
          //          @EndUserText.label: 'RR Date'
          //          @UI.hidden: true
          //          Rrdate,
          @EndUserText.label: 'LR/BL No'
          Lrblno,
          @EndUserText.label: 'LR/BL Date'
          Lbbldate,
          @EndUserText.label: 'Bill of Entry No'
          Billofentryno,
          @EndUserText.label: 'Bill of Entry Date'
          Billofentrydate,
          @EndUserText.label: 'Mining Permission No'
          Miningpermissionno,
          @EndUserText.label: 'Waybill No'
          Waybillno,
          @EndUserText.label: 'Mining Challan/TP'
          Miningchallantpno,
          @EndUserText.label: 'Plant No'
          Plantgateno,
          @EndUserText.label: 'Plant WeighBridge No'
          Plantweighbridgeno,
          @EndUserText.label: 'Shipment Type'
          Shipmenttype,
          @EndUserText.label: 'Vehicle No'
          Vehno,
          @EndUserText.label: 'Container No'
          ContainerNumber,
          @EndUserText.label: 'Vessel Name'
          Vesselname,
          //          @EndUserText.label: 'Rake No.'
          //          @UI.hidden: true
          //          Rakeno,
          //          @EndUserText.label: 'Rake Trip No.'
          //          @UI.hidden: true
          //          Raketripno,
          @EndUserText.label: 'Ernam'
          Ernam,
          @EndUserText.label: 'Erdat'
          Erdat,
          @EndUserText.label: 'Erzet'
          Erzet,
          @EndUserText.label: 'Gate Entry Date'
          Gateentrydate,
          @EndUserText.label: 'Gate Entry Time'
          Gateentrytime,
          @EndUserText.label: 'Vendor Net Weight'
          Vendor_Netwt,
          @EndUserText.label: 'Vendor Tare Weight'
          Vendor_Tarwt,
          @EndUserText.label: 'Vendor Gross Weight'
          Vendor_Grswt,
          @EndUserText.label: 'Vendor Code'
          Vendorcode,
          @EndUserText.label: 'Vendor Name'
          Vendorname,
          @EndUserText.label: 'Customer Code'
          Customercode,
          @EndUserText.label: 'Customer Name'
          Customername,
          @EndUserText.label: 'Driver Name'
          Drivername,
          @EndUserText.label: 'Driver Cell Number'
          Drivercellno,
          @EndUserText.label: 'Dl No'
          Dlno,
          @EndUserText.label: 'Vehicle Check'
          Vehiclecheck,
          @EndUserText.label: 'Test Certificate'
          Testcertificate,
          @EndUserText.label: 'Tax Invoice'
          Taxinvoice,
          @EndUserText.label: 'Transporter Code'
          Transportercode,
          @EndUserText.label: 'Transporter Name'
          Transportername,
          @EndUserText.label: 'Invoice'
          Invoice,
          @EndUserText.label: 'Invoice Date'
          Invoicedate,
          @EndUserText.label: 'Remarks'
          Remarks,
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Gateentry Number'
          Gatepass,
          @UI.hidden: true
          @EndUserText.label: 'Gatepass Date'
          Gatepassdate,
          @EndUserText.label: 'Purchasing Document Number'
          Purchasingdocumentnumber,
          @EndUserText.label: 'Vehicle Out Date'
          Vehicleoutdate,
          @EndUserText.label: 'Vehicle Out Time'
          Vehicleouttime,
          @EndUserText.label: 'Unload Date'
          Unloaddate,
          @EndUserText.label: 'Unload Time'
          Unloadtime,
          @EndUserText.label: 'Gateout'
          Gateout,
          @EndUserText.label: 'Deleted'
          Deleted,
          @EndUserText.label: 'Cancel'
          Cancel,
          @EndUserText.label: 'Print'
          TPrint,
          @EndUserText.label: 'Miscnumber'
          Miscnumber,
          @EndUserText.label: 'Miscdate'
          Miscdate,
          @EndUserText.label: 'Current Year'
          Currentyear,
          @EndUserText.label: 'Current Number'
          Currentnumber,
          @EndUserText.label: 'Bukrs'
          Bukrs,
          @EndUserText.label: 'Plant'
          Plant,

          @EndUserText.quickInfo: 'GatePass Type'
          @EndUserText.label: 'Gate Entry Type'
          Type,
          @EndUserText.label: 'Meins'
          Meins,
          @EndUserText.label: 'Netwt'
          Netwt,
          @EndUserText.label: 'Tarwt'
          Tarwt,
          @EndUserText.label: 'Grswt'
          Grswt,
          @EndUserText.label: 'Deleteuser'
          Deleteuser,
          @EndUserText.label: 'Deletedate'
          Deletedate,

          @EndUserText.label: 'Printr'
          Printr,
          @UI.hidden: true
          @EndUserText.label: 'Wlfpl'
          Wlfpl,
          @UI.hidden: true
          @EndUserText.label: 'Item'
          Item,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GATEPASS_WLPL'
  virtual ShowWlpl :abap_boolean,
          @EndUserText.label: 'From Place'
          Fromplace,
          @EndUserText.label: 'To Place'
          Toplace,
          @EndUserText.label: 'Multi Weight'
          Multiweight,
          @EndUserText.label: 'No of Weight'
          Noofweight,
          @EndUserText.label: 'MP NO'
          Mpno,
          @EndUserText.label: 'TP NO'
          Tpno,
          @EndUserText.label: 'Gatepass Number For RGP'
          rgpgatepass,
          @EndUserText.label: 'RGP Date'
          rgpdate,
          @EndUserText.label: 'Delivery Number'
          deliverynumber,
          @EndUserText.label: 'Sender Name'
          sendername,
          @EndUserText.label: 'Currency'
          Currency,
          @EndUserText.label: 'Total Price'
          Amountt,
          /* Associations */
          _Item : redirected to composition child ZC_GITEM

}
