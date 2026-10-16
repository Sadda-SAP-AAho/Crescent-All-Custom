@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG2
  as select distinct from ZCDS_INPUTREG1 as a
    left outer join       ZCDS_INPUTREG8 as b on(
      a.AccountingDocument = b.AccountingDocument
      and a.FiscalYear     = b.FiscalYear
      and a.CompanyCode    = b.CompanyCode
    )
    left outer join       I_Supplier     as c on(
      c.Supplier = a.Supplier
    )

{
  key    a.SourceLedger,
  key    a.CompanyCode,
  key    a.FiscalYear,
  key    a.AccountingDocument,
  key    a.LedgerGLLineItem,
  key    a.Ledger,
         a.BusinessArea,
         a.CompanyCodeName,
         a.ProfitCenter,
         a.Segment,
         a.Plant,
         a.DocumentDate,
         a.TransactionCurrency,
         a.GLAccount,
         a.GLAccountName,

         case
                  when a.AccountingDocumentType = 'KR'  then 'Invoice'
                  when a.AccountingDocumentType = 'RE'  then 'Invoice'
                  when a.AccountingDocumentType = 'KG'  then 'Credit Note'
                  when a.AccountingDocumentType = 'KZ'  then 'Payment Voucher'

                  end                                                                                                                                  as AccountingDocumentType,

         a.State,
         a.GSTIN,
         a.TransactionCount,
         a.Supplier,
         a.SupplierFullName,
         a.TaxNumber3,
         a.RegionName,
         a.ProductDescription,
         a.ConsumptionTaxCtrlCode,
         substring( a.ConsumptionTaxCtrlCode, 1,2 )                                                                                                    as taxcontrolcode,
         a.BaseUnit,
         @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
         a.quantity,
         @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
         a.AmountInTransactionCurrency,
         a.DocumentItemText,
         a.PostingDate,
         a.Pos,
         a.ReferenceQuantityUnit,
         a.CGSTRate,
         a.SGSTRate,
         a.IGSTRate,
         case when a.ProductGroup = 'RM01'
         then '400'
         else '000' end                                                                                                                                as Cess,
         a.TaxCode,
         cast( a.Taxablevalue  as abap.dec( 23,2 ) )                                                                                                   as Taxablevalue,
         ( a.CGSTRate + a.SGSTRate + a.IGSTRate )                                                                                                      as Totalgstrate,
         case when a.TaxCode = '7E'
         then cast(division( cast( a.taxval as abap.dec( 17,2 ) ) * cast( a.CGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) )
         else
          cast(division( cast( a.Taxablevalue as abap.dec( 17,2 ) ) * cast( a.CGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) ) end      as CGSTValue,
         case when a.TaxCode = '7E'
         then
         cast(division( cast( a.taxval as abap.dec( 17,2 ) ) * cast( a.SGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) )
         else  cast(division( cast( a.Taxablevalue as abap.dec( 17,2 ) ) * cast( a.SGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) ) end as SGSTValue,
         case when a.TaxCode = '7A'
         then
           cast(division( cast( a.taxval as abap.dec( 17,2 ) ) * cast( a.IGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) )
           else
         cast(division( cast( a.Taxablevalue as abap.dec( 17,2 ) ) * cast( a.IGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) ) end       as IGSTValue,
         case when a.ProductGroup = 'RM01'
         then case when a.taxval < 0
         then cast(      -1 *   a.quantity * 400                  as abap.dec( 23,2 ) )
         else
          cast(         a.quantity * 400                  as abap.dec( 23,2 ) ) end
          else cast(        0                 as abap.dec( 23,2 ) )   end                                                                              as CessValue,
         case
                  when a.TaxNumber3 is not initial or a.TaxNumber3 is not null   then 'Registered'
                 else
                 'Un-Registered'
                  end                                                                                                                                  as Natureofsupply,
         case
                  when c.Region = 'OD'   then 'Inter-state'

                  else
                  'Intra-state'
                  end                                                                                                                                  as SupplyType

}
where
  a.State <> 'DEL'
