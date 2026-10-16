@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Confirmation Item'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_CONF_ITM
  as projection on ZI_CONF_ITM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Shop Floor Number'
      Shpflrno,
      @EndUserText.label: 'Material No'
      Matnr,
      @EndUserText.label: 'Description'
      Maktx,
      @EndUserText.label: 'Total mould'
      Totmou,
      @EndUserText.label: 'Total mould Quantity'
      Totmouqty,
      @EndUserText.label: 'Good Cast'
      Goodcast,
      @EndUserText.label: 'Rej Qty 1'
      Rejqty1,
      @EndUserText.label: 'Rej Reason 1'
      Rejrea1,
      @EndUserText.label: 'Rej Qty 2'
      Rejqty2,
      @EndUserText.label: 'Rej Reason 2'
      Rejrea2,
      @EndUserText.label: 'Rej Qty 3'
      Rejqty3,
      @EndUserText.label: 'Rej Reason 3'
      Rejrea3,
      @EndUserText.label: 'Rej Qty 4'
      Rejqty4,
      @EndUserText.label: 'Rej Reason 4'
      Rejrea4,
      @EndUserText.label: 'Rej Qty 5'
      Rejqty5,
      @EndUserText.label: 'Rej Reason 5'
      Rejrea5,
      @EndUserText.label: 'Rej Qty 6'
      Rejqty6,
      @EndUserText.label: 'Rej Reason 6'
      Rejrea6,
      @EndUserText.label: 'Rej Qty 7'
      Rejqty7,
      @EndUserText.label: 'Rej Reason 7'
      Rejrea7,
      @EndUserText.label: 'Rej Qty 8'
      Rejqty8,
      @EndUserText.label: 'Rej Reason 8'
      Rejrea8,
      @EndUserText.label: 'Rej Qty 9'
      Rejqty9,
      @EndUserText.label: 'Rej Reason 9'
      Rejrea9,
      @EndUserText.label: 'Total Cast'
      Totcast,
      @EndUserText.label: 'UOM'
      Meins,
      @EndUserText.label: 'No of Head'
      Noofhead,
      @EndUserText.label: 'Prodn Order No'
      Prodord,
      @EndUserText.label: 'Pending Prodn Qty'
      Pendprqty,
      @EndUserText.label: 'Std Wt.'
      Stdwt,
      @EndUserText.label: 'Actual Wt.'
      Actwt,
      @EndUserText.label: 'Weight UOM'
      Wtunit,
      @EndUserText.label: 'Total Cast Quantity'
      Totqty,
      @EndUserText.label: 'Allocated Cast Quantity'
      Allocqty,
      @EndUserText.label: 'Balance Cast Quantity'
      Balqty,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Pattern'
      Pattern,
      @EndUserText.label: 'Machining loss'
      Machloss,
      @EndUserText.label: 'Qty. per box'
      Qtyperbox,
      @EndUserText.label: 'Sales Order Number'
      So,
      @EndUserText.label: 'Sales Order Line Item'
      Soitm,
      @EndUserText.label: 'FG Code Material'
      Sofg,
      @EndUserText.label: 'Metal Crate Qty'
      Metalcrqty,
      checkdel,
      checkcrt,
      /* Associations */
      _Head : redirected to parent ZC_CONF_HDR
      // _Ord : redirected to composition child ZC_CONF_ORD
}
