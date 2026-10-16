@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_16

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from I_BillingDocument     as a

    inner join   I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument

    inner join   zdt_costingpl_pc      as c on b.ProfitCenter = c.prctr
{

  key a.BillingDocument,
  key b.BillingDocumentItem,
      b.ItemWeightUnit,
      c.prctr,
      c.prctrclub,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      b.ItemNetWeight

}

where
      a.AccountingDocument         is not initial
  and a.BillingDocumentIsCancelled = ''
  and(
        a.BillingDocumentDate        >= $parameters.p_begin
    and a.BillingDocumentDate        <= $parameters.p_end
  )
