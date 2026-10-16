@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_20

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from    I_BillingDocument                                                        as a

    inner join      I_BillingDocumentItem                                                    as b  on a.BillingDocument = b.BillingDocument

    left outer join zdt_costingpl_pc                                                         as z3 on z3.prctr = b.ProfitCenter

    left outer join ZV_COSTINGPL_17( p_begin: $parameters.p_begin, p_end: $parameters.p_end) as z4 on z4.prctrclub = z3.prctrclub

    left outer join ZV_COSTINGPL_19( p_begin: $parameters.p_begin, p_end: $parameters.p_end) as z5 on z5.prctrclub = z3.prctrclub

{

  key a.BillingDocument,
  key b.BillingDocumentItem,
      b.ProfitCenter,
      z3.prctrclub,
      cast( b.ItemNetWeight as abap.dec(15,2) ) as ItemNetWeight,
      z4.BillingNetWeight,
      z5.AmountInCompanyCodeCurrency,
      case when z4.BillingNetWeight > 0 then
      cast( division( cast( b.ItemNetWeight as abap.dec(15,2) ), z4.BillingNetWeight, 2 ) as abap.dec(9,5) )
      else 0 end                                as DerivedRatio
}

where
        a.AccountingDocument         is not initial
  and   a.BillingDocumentIsCancelled = ''
  and(
        a.BillingDocumentDate        >= $parameters.p_begin
    and a.BillingDocumentDate        <= $parameters.p_end
  )
