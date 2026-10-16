@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View for Packing List Header'
define root view entity ZC_PACKLIST_HDR 
provider contract transactional_query
  as projection on ZI_PACKLIST_HDR
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Packing List'
    @Search.defaultSearchElement: true
    Packinglist,
    @EndUserText.label: 'Revision'
    Revision,
    @EndUserText.label: 'Delivery Number'
    Delivery,
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
    @EndUserText.label: 'Print'
    Prnt,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Export Draft Packing Print'
    Dprint,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Domestic Draft Packing Print'
    Domprint,
     @EndUserText.label: 'Domestic Draft Packing Print-HSN'
          Domprinthsn as Domprinthsn,
        @EndUserText.label: 'Export Draft Packing Print-HSN'
      Xportprinthsn as Xportprinthsn,
    @EndUserText.label: 'Contact Person'
    Contactp,
    @EndUserText.label: 'Contact Number'
    Contactn,
    @EndUserText.label: 'Package Type'
    Pkgtyp,
    @EndUserText.label: 'Customer Code'
    Customercode,
    @EndUserText.label: 'Customer Name'
    Customername,
    @EndUserText.label: 'Remarks'
    Remarks,
    /* Associations */
    _Item : redirected to composition child ZC_PACKLIST_ITM
}
