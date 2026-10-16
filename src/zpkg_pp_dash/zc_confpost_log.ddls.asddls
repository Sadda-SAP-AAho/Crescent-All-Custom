@EndUserText.label: 'Consumption View for Conf Post Log'
@Metadata.allowExtensions: true
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_CONFPOST_LOG
  as projection on ZI_CONFPOST_LOG
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Log Id'
  key Log,
      @EndUserText.label: 'Item'
      Refitem,
      @EndUserText.label: 'Orde Item'
      Reford,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Shop Floor Number'
      Shpflrno,
      @EndUserText.label: 'Material'
      Matnr,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Production Order'
      Prodord,
      @EndUserText.label: 'Qty'
      Qty,
      @EndUserText.label: 'UOM'
      Meins,
      @EndUserText.label: 'Posted By'
      Postedby,
      @EndUserText.label: 'Posted On'
      Postedon,
      @EndUserText.label: 'Posted At'
      @UI.hidden: true
      Postedat,
      @EndUserText.label: 'Unique id'
      Uniqueid,
      @EndUserText.label: 'Movement Type'
      Movtype,
      /* Associations */
     _Head : redirected to parent ZC_CONFPOST_HDR
}
