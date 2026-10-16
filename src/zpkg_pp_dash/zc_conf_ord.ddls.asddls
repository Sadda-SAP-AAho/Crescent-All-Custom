@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Conf Order'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_CONF_ORD 
as projection on ZI_CONF_ORD
{   
    @EndUserText.label: 'Id' 
    key Id,
    @EndUserText.label: 'Item'
    key Item,
    @EndUserText.label: 'Order Item'
    key Ord,
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
    @EndUserText.label: 'UOM'
    Meins,
    @EndUserText.label: 'Serial Number'
    Serial,
    @EndUserText.label: 'Heat Number'
    Heatno,
    @EndUserText.label: 'Rejected'
    Rej,
    @EndUserText.label: 'Status'
    Status,
    @EndUserText.label: 'Overall Status'
    Ovstatus,
    /* Associations */
     _Head : redirected to parent ZC_CONF_HDR
}
