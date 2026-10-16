@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor Prod-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SHPFLRRPT
  provider contract transactional_query
  as projection on ZI_SHPFLRRPT
{
      @EndUserText.label: 'Shop Floor No'
      @Search.defaultSearchElement: true
  key Shpflrno,
      @UI.hidden: true
  key itemkey,
      @UI.hidden: true
  key orderkey,
      @EndUserText.label: 'Shop Floor Date'
      Shpflrdt,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Create Date'
      CreatedOn,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Department'
      Dept,
      @EndUserText.label: 'Department Name'
      Deptname,
      @EndUserText.label: 'Operation'
      Opr,
      @EndUserText.label: 'Operation Name'
      Oprname,
      @EndUserText.label: 'Contractor'
      Cont,
      @EndUserText.label: 'Contractor Name'
      Contname,
      @EndUserText.label: 'Material No'
      Matnr,
      @EndUserText.label: 'Description'
      Maktx,
      @EndUserText.label: 'UoM'
      UnitOfMeasure_E,
      @EndUserText.label: 'Pattern'
      Pattern,
      @EndUserText.label: 'Total Mould'
      Totmou,
      @EndUserText.label: 'Good Cast'
      Goodcast,
      @EndUserText.label: 'Total Cast'
      Totcast,
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
      @UI.hidden: true
      Meins,
      @EndUserText.label: 'Std Wt.'
      Stdwt,
      @EndUserText.label: 'Act Wt.'
      Actwt,
      @UI.hidden: true
      Wtunit,
      @EndUserText.label: 'Total Cast Qty.'
      Totqty,
      @EndUserText.label: 'Allocated Cast Qty.'
      Allocqty,
      @EndUserText.label: 'Balance Cast Qty.'
      Balqty,
      @EndUserText.label: 'Machining Loss'
      Machloss,
      @EndUserText.label: 'Qty. per Box'
      Qtyperbox,
      @EndUserText.label: 'Total Mould Qty.'
      Totmouqty,
      @EndUserText.label: 'Sales Order No'
      So,
      @EndUserText.label: 'Sales Order Line Item'
      Soitm,
      @EndUserText.label: 'FG Code Material'
      Sofg,
      @EndUserText.label: 'Metal Crate Qty'
      Metalcrqty,
      @EndUserText.label: 'Production Order'
      Prodord,
      @EndUserText.label: 'Quantity'
      Pendprqty,
      @EndUserText.label: 'UOM'
      UOM,
      @EndUserText.label: 'Rejected'
      Rejected,
      @EndUserText.label: 'Serial Number'
      Serial,
      @EndUserText.label: 'Heat Number'
      Heatno
}
