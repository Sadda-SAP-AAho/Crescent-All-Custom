@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Forward Contract Item'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_FOREXTPITM
  as select from zdt_forex_itm
  association to parent ZI_FOREXTP as _head on $projection.Id = _head.Id
{
  key zdt_forex_itm.id            as Id,
  key zdt_forex_itm.item          as Item,
      zdt_forex_itm.contnoext     as Contnoext,
      zdt_forex_itm.adjustdoctype as Adjustdoctype,
      zdt_forex_itm.docno         as Docno,
      zdt_forex_itm.docdate       as Docdate,
      zdt_forex_itm.waers         as Waers,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_forex_itm.amt           as Amt,
      zdt_forex_itm.remarks       as Remarks,
      zdt_forex_itm.instructdate  as Instructdate,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_forex_itm.adjustval     as Adjustval,
      zdt_forex_itm.custref       as Custref,
      @Semantics.amount.currencyCode: 'Loancurr'
      zdt_forex_itm.loanamt       as Loanamt,
      zdt_forex_itm.loancurr      as Loancurr,
      @Semantics.amount.currencyCode: 'Salecurr'
      zdt_forex_itm.salesamt      as Salesamt,
      zdt_forex_itm.salecurr      as Salecurr,
      zdt_forex_itm.salesdate     as Salesdate,
      zdt_forex_itm.salesorder    as Salesorder,
      @Semantics.amount.currencyCode: 'Lcurr'
      zdt_forex_itm.lcamt         as Lcamt,
      zdt_forex_itm.lcurr         as Lcurr,
      zdt_forex_itm.loanaccno     as Loanaccno,
      zdt_forex_itm.othercurr     as Othercurr,
      @Semantics.amount.currencyCode: 'Othercurr'
      zdt_forex_itm.otheramt      as Otheramt,
      zdt_forex_itm.othertext     as Othertext,
      zdt_forex_itm.lcnum         as Lcnum,
      zdt_forex_itm.fiscalyear    as Fiscalyear,
      zdt_forex_itm.companycode   as Companycode,
      
      _head // Make association public
}
