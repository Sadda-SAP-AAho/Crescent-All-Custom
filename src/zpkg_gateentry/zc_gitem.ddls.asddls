@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'GatePass Item'
define view entity ZC_GITEM
  as projection on ZI_GITEM
{
          @EndUserText.label: 'ID'
  key     Id,
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Item'
  key     Item,
          @EndUserText.label: 'GatePass No.'
          Gatepass,
          @EndUserText.label: 'Order'
          Ebeln,
          @EndUserText.label: 'Item'
          Ebelp,
          @EndUserText.label: 'Delivery Doc'
          Vbeln,
          @EndUserText.label: 'Delivery Item'
          Vbelp,
          @EndUserText.label: 'Return By Date'
          creationdate,
          @EndUserText.label: 'Material'
          Matnr,
          @EndUserText.label: 'Material Desc'
          Maktx,
          @EndUserText.label: 'PO Item long text'
          Potext,
          @EndUserText.label: 'Vendor'
          Vendor,
          //Posnr,
          //VbelnVf,
          //PosnrVf,
          @EndUserText.label: 'Material Doc'
          Mblnr,
          @EndUserText.label: 'Material Doc Year'
          Mjahr,
          @EndUserText.label: 'Material Doc Item'
          Zeile,
          @EndUserText.label: 'UoM'
          @Semantics.unitOfMeasure: true
          Meins,
          @EndUserText.label: 'Customer Number'
          Custcode,
          @EndUserText.label: 'Customer Description'
          Custdesc,
          @EndUserText.label: 'Invoice Number'
          Invoice,
          @EndUserText.label: 'Plant Qty.'              //By SN for plant and challan heading changes   
          Challanqty,
          @EndUserText.label: 'Challan Qty.'              
          Plantqty,
          @EndUserText.label: 'Order Qty.'
          Orderqty,
          @EndUserText.label: 'Total Qty.'
          Totalqty,
          @EndUserText.label: 'Balance Qty.'
          Balanceqty,
          @EndUserText.label: 'Deliver Qty.'
          Deliverqty,
          @EndUserText.label: 'gate item'
          gateitem,
          @EndUserText.label: 'Net Weight'
          netwt,
          @EndUserText.label: 'Tare Weight'
          tarwt,
          @EndUserText.label: 'Gross Weight'
          grswt,
          @EndUserText.label: 'Weight Unit'
          Wtunit,
          @EndUserText.label: 'Challan Value'
          Itemval,
          @EndUserText.label: 'Challan Value'
          Itemval1,
          @EndUserText.label: 'Currency'
          Currency,
          //  Virtual Elements to control the Fields Dynamically
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GATEPASS_SHOWPO'
  virtual ShowPO    :abap_boolean,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GATEPASS_SHOWNPO'
  virtual ShowNPO   :abap_boolean,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GATEPASS_SHOWSALES'
  virtual ShowSALES :abap_boolean,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GATEPASS_SHOWSR'
  virtual ShowSR    :abap_boolean,


          _Head.Plantgateno as Plantgateno,
          _Head.Type        as Type,
          @EndUserText.label: 'Plant'
          plant,
          @EndUserText.label: 'Unique Order and Item Combination'
          pounique,
          @EndUserText.label: 'Mining Permission Number'
          @UI.hidden: true
          mpno,
          @EndUserText.label: 'Transit Pass Number'
          @UI.hidden: true
          tpno,
          //          @EndUserText.label: 'Unique Order and Item Combination for STO'
          //          pouniquesto,
          @EndUserText.label: 'Vehicle Number'
          vehno,
          @EndUserText.label: 'Copy'
          Copy,
          @EndUserText.label: 'Price'
          tamount,
          /* Associations */
          _Head : redirected to parent ZC_GHEAD

}
