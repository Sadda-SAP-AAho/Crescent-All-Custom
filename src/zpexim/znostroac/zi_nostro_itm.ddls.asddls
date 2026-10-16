@EndUserText.label: 'Interface View for NOSTRO Item'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_NOSTRO_itm
  as select from zdt_nostro_itm
  association to parent ZI_NOSTRO_hed as _Head on $projection.Id = _Head.Id
{
  key id                     as Id,
  key item                   as Item,
      checkbox               as Checkbox,
      accountingdocument     as Accountingdocument,
      accountingdocumentitem as accountingdocumentitem,
      referenceno            as Referenceno,
      accountingdocumenttype as Accountingdocumenttype,
      documentdate           as Documentdate,
      postingdate            as Postingdate,
      amountdc               as Amountdc,
      currencydc             as Currencydc,
      remainamtdc            as remainamtdc,
      amountcc               as Amountcc,
      currencycc             as Currencycc,
      payterm                as payterm,
      duedate                as Duedate,
      inwardrefno            as Inwardrefno,
      inwarddate             as Inwarddate,
      swiftdate              as Swiftdate,
      inwardamount           as Inwardamount,
      currencyinward         as Currencyinward,
      inwardrecordstatus     as Inwardrecordstatus,
      accupdateitm           as Accupdateitm,
      _Head // Make association public
}
