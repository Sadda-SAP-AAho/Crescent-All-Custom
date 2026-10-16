@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gateentry register consumption view'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_LABELPRINT_N
  provider contract transactional_query
  as projection on ZI_LABELPRINT_N
{

      @EndUserText.label: 'Packing List No'
      @Search.defaultSearchElement: true
      @UI.hidden: true
  key PackingList,
      @UI.hidden: true
  key Inv_No,
      @EndUserText.label: 'Priority'
  key Priority,
      @UI.hidden: true
  key itemkey,
      @EndUserText.label: 'Serial No'
      Sl_No,
      @EndUserText.label: 'Item'
      Item,
      @EndUserText.label: 'Packing/Crate'
      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      Packing_Crate,
      @EndUserText.label: 'Unit'
      UOM,
      @EndUserText.label: 'Net Weight/Pack'
      Net_WtPack,
      @UI.hidden: true
      Unit,
      @EndUserText.label: 'Gross Weight/Pack'
      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      GrossWt_Pack,
      @UI.hidden: true
      UnitofMeasure,
      @EndUserText.label: 'Invoice No'
      Invoice_No,
      @EndUserText.label: 'PO No'
      PO_No,
      @EndUserText.label: 'Qty'
      Qty,
      @EndUserText.label: 'Item Description'
      Item_Description,
      @EndUserText.label: 'Packing Instruction (No.)'
      Pack_Instr,
      @EndUserText.label: 'Drawing No'
      Drawing_No,
      @EndUserText.label: 'Art No'
      Art_No
}
