@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Conf Post Order'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_CONFPOST_ORD
  as projection on ZI_CONFPOST_ORD
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Order Item'
  key Ord,
      @EndUserText.label: 'Ref Id'
      Refid,
      @EndUserText.label: 'Ref Item'
      RefItem,
      @EndUserText.label: 'Ref Order Item'
      Reford,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Shop Floor Number'
      Shpflrno,
      @EndUserText.label: 'Material'
      Matnr,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Production order'
      Prodord,
      @EndUserText.label: 'Quantity'
      Pendprqty,
      @EndUserText.label: 'Posting Quantity'
      Postqty,
      @EndUserText.label: 'Pending Quantity'
      Balqty,
      @EndUserText.label: 'Already Posted Quantity'
      Alpostqty,
      @EndUserText.label: 'UOM'
      Meins,
      @EndUserText.label: 'Serial'
      Serial,
      @EndUserText.label: 'Heat Number'
      Heatno,
      @EndUserText.label: 'Rejected'
      Rej,
      @EndUserText.label: 'Order Status'
      Ordersta,
      @EndUserText.label: 'Document Status'
      Docsta,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Unique Id'
      @UI.hidden: true
      Uniqueid,
      @EndUserText.label: 'Progress Bar'
      Progress,
      @EndUserText.label: 'Total'
      Total,
      @EndUserText.label: 'Criticality'
      Criticality,
      /* Associations */
      _Head : redirected to parent ZC_CONFPOST_HDR
}
