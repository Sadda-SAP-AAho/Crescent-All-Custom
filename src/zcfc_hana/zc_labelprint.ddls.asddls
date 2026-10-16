@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gateentry register consumption view'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_LABELPRINT
  provider contract transactional_query
  as projection on ZI_LABELPRINT
{

      @EndUserText.label: 'Packing List No'
      @Search.defaultSearchElement: true
      @UI.hidden: true
  key PackingList,
      @UI.hidden: true
  key itemkey,
      @EndUserText.label: 'Item'
      Item,
      @EndUserText.label: 'Packing/Crate'
      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      Packing_Crate,
      @EndUserText.label: 'Unit'
      UOM,
      @EndUserText.label: 'Net Weight/Pack'
      Net_WtPack,
      @EndUserText.label: 'UOM'
      Unit,
      @EndUserText.label: 'Gross Weight/Pack'
      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      GrossWt_Pack,
      @EndUserText.label: 'UOM'
      UnitofMeasure,
      @EndUserText.label: 'Invoice No'
      Invoice_No,
      @EndUserText.label: 'PO No'
      PO_No,
      @EndUserText.label: 'Qty'
      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      Qty,
      @EndUserText.label: 'Item Description'
      Item_Description
}
