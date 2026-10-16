@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption for Spcl Price for M/L Line'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_SPCLPRCEMLL as projection on ZI_SPCLPRCEMLL
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Item'
    key Item,
    @EndUserText.label: 'from Date'
    Fromdate,
    @EndUserText.label: 'To Date'
    Todate,
    @EndUserText.label: 'Unit'
    Unit,
    @EndUserText.label: 'Currency'
    Currency,
    @EndUserText.label: 'Rate'
    Rate,
    /* Associations */
    _Head : redirected to parent ZC_SPCLPRCEMLH
} 
