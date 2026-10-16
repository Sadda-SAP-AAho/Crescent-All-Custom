@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'INTERFACE VIEW FOR LABOUR BOOK'
@ObjectModel.representativeKey: 'ID'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_LABOUR_BOOK as select from zlabour_book
composition [0..*] of ZI_LABOUR_BOOK_ITEM as _items
{
     key id as ID,
     fisyear as Fisyear,
     keyid as Keyid,
     creon as Creon,
     creby as Creby,
     docnum as Docnum,
     reportdate as Reportdate,
     plantcode as Plantcode,
     plantname as Plantname,
     costcentercode as Costcentercode,
     costcentername as Costcentername,
     contractorcode as Contractorcode,
     contractorname as Contractorname,
     operationcode as Operationcode,
     operationname as Operationname,
    _items
}
