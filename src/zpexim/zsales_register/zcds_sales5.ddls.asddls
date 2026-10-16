@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Sales Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SALES5 as select from ZCDS_SALES4  as a
{
    a.BillingDocument,
    a.BillingDocumentItem,
    a.TransactionCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency' 
    sum( case a.Aa
         when 'A'
         then a.ConditionAmnt end ) as sum_a,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.Bb
         when 'B'
         then a.ConditionAmnt end ) as sum_b, 
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.Cc
         when 'C'
         then a.ConditionAmnt end ) as sum_c,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.Cc
         when 'C'
         then a.ConditionAmnt end ) as DISCinDc,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.Ee
         when 'E'
         then a.ConditionAmnt end ) as ExportFreight,
          @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.Ff
         when 'F'
         then a.ConditionAmnt end ) as IGSTAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.Gg
         when 'G'
         then a.ConditionAmnt end ) as CGSTAmount,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.ConditionType
         when 'H'
         then a.ConditionAmnt end ) as SGSTAmount,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
//    sum( case a.ConditionType
//         when 'D'
//         then a.CondRateValue end ) as DISC
         
    sum( case a.Cc
           when 'C'
           then a.CondRateValue end ) as DISC,
// Added by SP on 16.06.25   
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( case a.Ii
         when 'I'
         then a.ConditionAmnt end ) as TCSAmount        
// End of Added by SP on 16.06.25     
              
}  group by a.BillingDocument,a.BillingDocumentItem, a.TransactionCurrency
