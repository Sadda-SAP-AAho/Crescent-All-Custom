@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'PROJECTION VIEW ZI_LABOUR_BOOK'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_LABOUR_BOOK
provider contract transactional_query 
as projection on ZI_LABOUR_BOOK
{
 
   @EndUserText.label: 'ID'
   key ID,
   @EndUserText.label: 'Fiscal Year'
   Fisyear,
   @EndUserText.label: 'Key ID'
   Keyid,
   @EndUserText.label: 'Created On'
   Creon,
   @EndUserText.label: 'Created By'
   Creby,
   @EndUserText.label: 'Document Number'
   Docnum,
   @EndUserText.label: 'Report Date'
   Reportdate,
   @EndUserText.label: 'Plant Code'
   Plantcode,
   @EndUserText.label: 'Plant Name'
   Plantname,
   @EndUserText.label: 'Cost Center Code'
   Costcentercode,
   @EndUserText.label: 'Cost Center Name'
   Costcentername,
   @EndUserText.label: 'Contractor Code'
   Contractorcode,
   @EndUserText.label: 'Contractor Name'
   Contractorname,
   @EndUserText.label: 'Operation Code'
   Operationcode,
   @EndUserText.label: 'Operation Name'
   Operationname,
    _items :redirected to composition child ZC_LABOUR_BOOK_ITEM
}
