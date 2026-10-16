@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'OC Form Print'
define root view entity ZC_OCFORM_ITEM
 provider contract transactional_query
 as projection on ZI_OCFORM_ITEM
{
      @EndUserText.label: 'Order No'
      @Search.defaultSearchElement: true
  key OrdNo,
      @UI.hidden: true
  key SoItem,
     @EndUserText.label: 'Item Code'
      ItemCode,
      @EndUserText.label: 'Description'
      Description,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'RevisionNo '
      RevisionNo,
     // @EndUserText.label: 'Paint'
      //Paint,
      @EndUserText.label: 'PO No.'
      PONo,
      @EndUserText.label: 'PO DT'
      PODT,
      @EndUserText.label: 'Qty'
      Quantity,
      @UI.hidden: true
      QuantityUnit,
      @EndUserText.label: 'Unit WT(Kg)'
      UnitWt,
      @EndUserText.label: 'Rate'
      Rate,
      @EndUserText.label: 'Total'
      Total,
      @UI.hidden: true
      Curr
}
