@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Clubbing Doc Type F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CLUBBILDOCF4TP

  as select from    I_BillingDocumentItemBasic as a

    inner join      I_BillingDocumentBasic     as b on b.BillingDocument = a.BillingDocument

    inner join      I_ProductPlantBasic        as c on  c.Product = a.Product
                                                    and c.Plant   = a.Plant

    left outer join ZI_CLUBBILDOCF4TP_2        as d on  d.invoice = a.BillingDocument
                                                    and d.posnr   = a.BillingDocumentItem

{

  key a.BillingDocument,
  key a.BillingDocumentItem,
      a.Product,
      a.BillingDocumentItemText,
      a.Plant,
      a.Batch,
      a.SalesOffice,
      a.SalesOrganization,
      a.DistributionChannel,
      a.Division,
      c.ConsumptionTaxCtrlCode                       as HSNSAC,
      cast( a.BillingQuantity as abap.dec( 15, 3 ) ) as BillingQuantity,
      a.BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      a.ItemGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      a.ItemNetWeight,
      a.ItemWeightUnit,
      cast( a.NetAmount as abap.dec( 15, 2 ) )       as NetAmount,
      a.TransactionCurrency,
      case when d.released is not null and d.released is not initial then 'X'
      else ''
      end                                            as UsageIndicator

}

where
  b.BillingDocumentIsCancelled is initial
