@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register Short Form Report'
@Search.searchable: true

define view entity ZC_GTENTRY_RECO_RPTTST
  as select from ZI_GTENTRY_RECO_RPTTST
{
      @UI.hidden: true
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'PO NO'
  key PurchaseOrder,
      @EndUserText.label: 'PO Line No'
  key PurchaseOrderItem,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Matl Code'
      Matnr,
      @EndUserText.label: 'Matl Name'
      Maktx,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Vendor Code'
      Vendor,
      @EndUserText.label: 'PO Txt'
      Potext,
      @EndUserText.label: 'GateEntry No'
      Gatepass,
      @EndUserText.label: 'GateentryDt'
      Gateentrydate,
      @EndUserText.label: 'Challan No'
      Challannumber,
      @EndUserText.label: 'Challan Dt'
      Challandate,
      @EndUserText.label: 'ShipType'
      Shipmenttype,
      @EndUserText.label: 'Vehicle No'
      Vehno,
      @EndUserText.label: 'Created By'
      PersonFullName,
      @EndUserText.label: 'Created Date'
      CreationDate,
      @EndUserText.label: 'Transporter Name'
      Vesselname,
      @EndUserText.label: 'From Place'
      Fromplace,
      @UI.hidden: true
      Meins,
      @EndUserText.label: 'To Place'
      Toplace,
      @EndUserText.label: 'Order Qty'
      Orderqty,
      @EndUserText.label: 'Challan Qty'
      Challanqty,
      @EndUserText.label: 'Plant Qty'
      Plantqty,
      @EndUserText.label: 'Deliver Qty'
      Deliverqty,
      @EndUserText.label: 'Net Wt'
      netwt,
      @EndUserText.label: 'Tare Wtr'
      tarwt,
      @EndUserText.label: 'Gross Wt'
      grswt,
      @EndUserText.label: 'WtUnit'
      Wtunit,
      @EndUserText.label: 'MatlDocNo'
      MaterialDocument,
      @EndUserText.label: 'Posting Dt'
      PostingDate,
      @EndUserText.label: 'Doc Dt'
      DocumentDate,
      @UI.hidden: true
      MaterialBaseUnit,
      @EndUserText.label: 'Qty'
      QuantityInBaseUnit,
      @EndUserText.label: 'Movement Type'
      GoodsMovementType,
      @EndUserText.label: 'Storage Location'
      StorageLocation
}
