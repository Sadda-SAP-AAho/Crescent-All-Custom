@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry Reco Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_GATEENTRYRECO
  provider contract transactional_query
  as projection on ZI_GATEENTRYRECO
{
      @EndUserText.label: 'Type'
  key Type,
      @UI.hidden: true
  key Id,
      @UI.hidden: true
  key Item,
      @UI.hidden: true
  key MaterialDocument,
      @EndUserText.label: 'PO Type Code'
      POType,
      @EndUserText.label: 'PO Type Name'
      POTypeName,
      @EndUserText.label: 'PO No.'
      @Search.defaultSearchElement: true
      PONo,
      @EndUserText.label: 'PO Line No.'
      POLine,
      @EndUserText.label: 'Vendor Code'
      VenodrCode,
      @EndUserText.label: 'Vendor Name'
      VenodrName,
      @EndUserText.label: 'Material No.'
      MatlCode,
      @EndUserText.label: 'Description'
      MatlName,
      @EndUserText.label: 'PO Text'
      POText,
      @EndUserText.label: 'Gate Entry No.'
      GateEntryNo,
      @EndUserText.label: 'Gate Entry Date'
      GateEntryDt,
      @EndUserText.label: 'Challan No.'
      ChallanNo,
      @EndUserText.label: 'Challan Date'
      ChallanDt,
      @EndUserText.label: 'Plant Code'
      PlantCode,
      @EndUserText.label: 'Plant Name'
      PlantName,
      @EndUserText.label: 'Shipment Type'
      ShipmentTyp,
      @EndUserText.label: 'Vehicle No.'
      VehicleNo,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Ctreated On'
      CreatedOn,
      @EndUserText.label: 'Transporter Code'
      TranspoterCode,
      @EndUserText.label: 'Transporter Name'
      TransporterName,
      @EndUserText.label: 'From Place'
      FromPlace,
      @EndUserText.label: 'To Place'
      ToPlace,
      @UI.hidden: true
      meins,
      @EndUserText.label: 'Order Qty.'
      OrderQty,
      @EndUserText.label: 'Challan Qty.'
      ChallanQty,
      @EndUserText.label: 'Plant Qty.'
      PlantQty,
      @EndUserText.label: 'Delivery Qty.'
      DelQty,
      @UI.hidden: true
      wtunit,
      @EndUserText.label: 'Net Weight'
      NetWt,
      @EndUserText.label: 'Tare Weight'
      TareWt,
      @EndUserText.label: 'Gross Weight'
      GrossWt,
      @EndUserText.label: 'Material Document No.'
      MatlDocNo,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Document Date'
      DocumentDate,
      @UI.hidden: true
      BaseUnit,
      @EndUserText.label: 'Quantity'
      Qty,
      @EndUserText.label: 'Storage Location'
      StorageLocation
}
