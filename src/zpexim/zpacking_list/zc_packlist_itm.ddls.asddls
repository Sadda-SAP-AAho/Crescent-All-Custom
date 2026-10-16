@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View for Packing List Item'
define view entity ZC_PACKLIST_ITM 
as projection on ZI_PACKLIST_ITM
{
    @EndUserText.label: 'Id'
    key Id,
    @EndUserText.label: 'Item'
    key Item,
    @EndUserText.label: 'Packing List'
    @Search.defaultSearchElement: true
    Packinglist,
    @EndUserText.label: 'Delivery Number'
    Delivery,
    @EndUserText.label: 'Delivery Item'
    Posnr,
    @EndUserText.label: 'Plant'
    Plant,
    @EndUserText.label: 'Material'
    Matnr,
    @EndUserText.label: 'Description'
    Maktx,
    @EndUserText.label: 'UOM'
    @Semantics.unitOfMeasure: true
    Meins,
    @EndUserText.label: 'Delivery Qty'
    Qty,
    @EndUserText.label: 'No. of Packages'
    Packqty,
    @EndUserText.label: 'Priority'
    Priority,
    @EndUserText.label: 'Pack Material'
    Packmat,
    @EndUserText.label: 'Package Wt'
    Packmatnwt,
    @EndUserText.label: 'Material Net Wt'
    Matnetwt,
    @EndUserText.label: 'Each Pkg Net Wt'
    Eachnetwt,
    @EndUserText.label: 'Each Pkg Gross Wt'
    Eachgrowt,
    @EndUserText.label: 'Net Weight'
    Netwt,
    @EndUserText.label: 'Gross Weight'
    Growt,
    @EndUserText.label: 'Weight UOM'
    Wtunit,
    @EndUserText.label: 'Pack Material Type'
    Packmattyp,
    @EndUserText.label: 'Material in Each Package'
    Mateachpkg,
    @EndUserText.label: 'Copy'
    Copy,
    /* Associations */
    _Head : redirected to parent ZC_PACKLIST_HDR
}
