@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for FOREX Adj. Details Rpt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_FOREXADJDETRPT
  as select from    ZI_FOREXTP    as a
    left outer join ZI_FOREXTPITM as b on a.Id = b.Id
{
  key a.Id,
  key b.Item,
      a.Contractdate,
      a.Contnoext,
      a.Bookdate,
      a.Opendate,
      a.Maturitydate,
      a.Waers,
      @Semantics.amount.currencyCode: 'Waers'
      a.Contamt,
      @Semantics.amount.currencyCode: 'Waers'
      a.Balanceval,
      a.Exchangerate,
      a.Bankname,
      b.Adjustdoctype,
      b.Salesorder,
      b.Salesdate,
      b.Salecurr,
      @Semantics.amount.currencyCode: 'Salecurr'
      b.Salesamt,
      b.Remarks,
      b.Instructdate,
      @Semantics.amount.currencyCode: 'Waers'
      b.Adjustval,
      b.Custref


}
