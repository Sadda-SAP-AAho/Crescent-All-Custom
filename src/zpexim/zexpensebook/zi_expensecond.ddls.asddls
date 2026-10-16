@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Expanse Condition'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_EXPENSECOND
  as select from zdt_expensecond
{
  key id          as id,
  key companycode as companycode,
      percontship as percontship,
      contsize    as Contsize,
      cast(shipline as abap.char(100))    as Shipline,
      forwarder   as Forwarder,
      countrydest as Countrydest,
      expansetype as Expansetype,
      fromdate    as Fromdate,
      todate      as Todate,
      @Semantics.amount.currencyCode: 'Currency'
      amount      as Amount,
      currency    as Currency
}
