@EndUserText.label: 'Interface View for NOSTRO Item'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_NOSTRO_ITM2
  as select from zdt_nostro_itm2
  association to parent ZI_NOSTRO_hed as _Head on $projection.Id = _Head.Id
{
  key zdt_nostro_itm2.id                     as Id,
      //  key zdt_nostro_itm2.item                   as Item,
  key zdt_nostro_itm2.item2                  as Item2,
      zdt_nostro_itm2.checkbox               as Checkbox,
      zdt_nostro_itm2.accountingdocument     as Accountingdocument,
      zdt_nostro_itm2.accountingdocumentitem as Accountingdocumentitem,
      zdt_nostro_itm2.referenceno            as Referenceno,
      zdt_nostro_itm2.accountingdocumenttype as Accountingdocumenttype,
      zdt_nostro_itm2.documentdate           as Documentdate,
      zdt_nostro_itm2.postingdate            as Postingdate,
      zdt_nostro_itm2.amountdc               as Amountdc,
      zdt_nostro_itm2.currencydc             as Currencydc,
      zdt_nostro_itm2.remainamtdc            as Remainamtdc,
      zdt_nostro_itm2.amountcc               as Amountcc,
      zdt_nostro_itm2.currencycc             as Currencycc,
      zdt_nostro_itm2.payterm                as Payterm,
      zdt_nostro_itm2.duedate                as Duedate,
      zdt_nostro_itm2.inwardrefno            as Inwardrefno,
      zdt_nostro_itm2.inwarddate             as Inwarddate,
      zdt_nostro_itm2.swiftdate              as Swiftdate,
      zdt_nostro_itm2.inwardamount           as Inwardamount,
      zdt_nostro_itm2.currencyinward         as Currencyinward,
      zdt_nostro_itm2.inwardrecordstatus     as Inwardrecordstatus,
      zdt_nostro_itm2.accupdateitm           as Accupdateitm,
      zdt_nostro_itm2.bankrefno              as bankrefno,
      zdt_nostro_itm2.bankintidt             as Bankintidt,

      _Head
}
