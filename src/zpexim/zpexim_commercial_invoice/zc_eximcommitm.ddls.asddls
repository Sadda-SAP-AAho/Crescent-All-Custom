@EndUserText.label: 'Commercial Item'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCOMMITM

  as projection on ZI_EXIMCOMMITM

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Billing Document'
      Invoice,
      @EndUserText.label: 'Billing Document Item'
      Invoiceitem,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc.'
      Materialdescription,
      @EndUserText.label: 'UoM'
      Uom,
      @EndUserText.label: 'Quantity'
      Quantity,
      @EndUserText.label: 'Weight UoM'
      Weightuom,
      @EndUserText.label: 'Net Weight'
      Netweight,
      @EndUserText.label: 'Gross Weight'
      Grossweight,
      @EndUserText.label: 'Packing Weight'
      Packingweight,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Rate'
      Rate,
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'Package Remarks'
      Packageremarks,
      @EndUserText.label: 'Size Remarks'
      Sizeremarks,
      @EndUserText.label: 'Harmonic Code'
      Harmoniccode,
      @EndUserText.label: 'Delivery'
      Delivery,
      @EndUserText.label: 'Delivery Item'
      Deliveryitem,
      @EndUserText.label: 'Sales Document'
      Salesorder,
      @EndUserText.label: 'Sales Document Item'
      Salesorderitem,
      @EndUserText.label: 'Contract'
      Contract,
      @EndUserText.label: 'Contract Item'
      Contractitem,
      @EndUserText.label: 'Reference'
      Reference,

      /* Associations */
      _head : redirected to parent ZC_EXIMCOMMHDR

}
