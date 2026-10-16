@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View for Final Packing List Header'
define root view entity ZC_FINALPACK_HDR
provider contract transactional_query
  as projection on zi_finalpack_hdr
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Packing List'
    @Search.defaultSearchElement: true
    Packinglist,
    @EndUserText.label: 'Commercial Invoice Number'
    comm_inv,
    @EndUserText.label: 'Sales Org.'
    Salesorg,
    @EndUserText.label: 'Plant'
    Plant,
    @EndUserText.label: 'Created By'
    Createdby,
    @EndUserText.label: 'Created On'
    Createdon,
    @EndUserText.label: 'Created At'
    Createdat,
    @EndUserText.label: 'Last Changed By'
    Changeddby,
    @EndUserText.label: 'Last Changed On'
    Changedon,
    @EndUserText.label: 'Last Changed At'
    Changedat,
    @EndUserText.label: 'Cancel Indictor'
    Canind,
    @EndUserText.label: 'Cancel By'
    Cancelby,
    @EndUserText.label: 'Cancel On'
    Cancelon,
    @EndUserText.label: 'Status'
    Status,
    @EndUserText.label: 'Cancel'
    Cancel,
    @EndUserText.label: 'Final Packing List Print'
    Prnt,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Draft Packing Print'
    Dprint,
    @EndUserText.label: 'Update Item'
    updateitem,
    @EndUserText.label: 'Remarks'
    Remarks,
    @EndUserText.label: 'Customer Freight'
    Custfrght,
    /* Associations */
    _Item : redirected to composition child ZC_FINALPACK_ITM,
    _Item1 : redirected to composition child ZC_FPLPRINTFIELD
    
}
