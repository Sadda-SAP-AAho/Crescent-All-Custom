@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'INTERFACE VIEW FOR LABOUR BOOK ITEM'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_LABOUR_BOOK_ITEM 
as select from zlabor_book_item
association to parent ZI_LABOUR_BOOK as _Head on $projection.Id = _Head.ID
{
    key id as Id,
    key item as Item,
    workcode as Workcode,
    workname as Workname,
    uom as Uom,
    quantity as Quantity,
    rate as Rate,
    amount as Amount,
    approvedbycode as Approvedbycode,
    approvedbyname as Approvedbyname,
    _Head
}
