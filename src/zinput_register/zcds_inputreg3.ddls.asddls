@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCDS_INPUTREG3
  as select distinct from ZCDS_INPUTREG2            as A
    left outer join       ZCDS_INPUTREG6            as B   on(
        A.SourceLedger           = B.SourceLedger
        and A.CompanyCode        = B.CompanyCode
        and A.FiscalYear         = B.FiscalYear
        and A.AccountingDocument = B.AccountingDocument
        and A.Ledger             = B.Ledger

      )
    left outer join       ZCDS_INPUTREG11           as zz  on  zz.AccountingDocument = A.AccountingDocument
                                                           and zz.CompanyCode        = A.CompanyCode
                                                           and zz.FiscalYear         = A.FiscalYear
    left outer join       I_JournalEntryItem        as dd  on(
       A.SourceLedger              = dd.SourceLedger
       and A.CompanyCode           = dd.CompanyCode
       and A.FiscalYear            = dd.FiscalYear
       and A.AccountingDocument    = dd.AccountingDocument
       and A.Ledger                = dd.Ledger
       and dd.FinancialAccountType = 'K'

     )
    left outer join       I_JournalEntry            as ddd on(
      A.CompanyCode            = ddd.CompanyCode
      and A.FiscalYear         = ddd.FiscalYear
      and A.AccountingDocument = ddd.AccountingDocument

    )
    left outer join       I_Supplier                as c   on c.Supplier = dd.Supplier
    left outer join       I_RegionText              as d   on  d.Country  = c.Country
                                                           and d.Region   = c.Region
                                                           and d.Language = $session.system_language

    left outer join       I_AE_CnsmpnTaxCtrlCodeTxt as o   on o.ConsumptionTaxCtrlCode = A.ConsumptionTaxCtrlCode

{
  key    A.SourceLedger,
  key    A.CompanyCode,
  key    A.FiscalYear,
  key    A.AccountingDocument,
  key    A.LedgerGLLineItem,
  key    A.Ledger,
         A.BusinessArea,
         A.CompanyCodeName,
         A.ProfitCenter,
         A.Segment,
         A.Plant,
         A.DocumentDate,
         substring(ddd.PostingDate, 5,2)                                                        as Month1,
         A.TransactionCurrency,
         A.GLAccount,
         A.GLAccountName,
         A.AccountingDocumentType,
         A.State,
         A.GSTIN,
         A.TransactionCount,
         c.Supplier,
         c.SupplierName                                                                         as SupplierFullName,
         c.TaxNumber3,
         d.RegionName,
         A.ProductDescription,
         A.ConsumptionTaxCtrlCode,
         o.ConsumptionTaxCtrlCodeText1,
         A.BaseUnit,
         @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
         A.quantity,
         @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
         cast( B.AmountInTransactionCurrency as abap.dec( 13, 3 )  )                            as AmountInTransactionCurrency,
         ddd.DocumentReferenceID                                                                as documentitemtext,
         A.PostingDate,
         A.Pos,
         A.ReferenceQuantityUnit,
         A.CGSTRate,
         A.SGSTRate,
         A.IGSTRate,
         A.Cess,
         A.Taxablevalue,
         A.Totalgstrate,
         A.CGSTValue,
         A.SGSTValue,
         A.IGSTValue,
         A.CessValue,

         A.TaxCode,
         case
               when ( A.CGSTRate is not initial or
                      A.SGSTRate is not initial or
                      A.IGSTRate is not initial )
                then 'Taxable'
              else
              'NonGST'
               end                                                                              as Taxability,
         case when A.TaxCode = '3A'
                    then 'Y'
                    when A.TaxCode = '3A'
                    then 'Y'
                    when A.TaxCode = '3B'
                    then 'Y'
                    when A.TaxCode = '3C'
                    then 'Y'
                    when A.TaxCode = '3D'
                    then 'Y'
                    when A.TaxCode = '3E'
                    then 'Y'
                    when A.TaxCode = '3F'
                    then 'Y'
                    when A.TaxCode = '3G'
                    then 'Y'
                    when A.TaxCode = '3H'
                    then 'Y'
                    when A.TaxCode = '4A'
                    then 'Y'
                    when A.TaxCode = '4B'
                    then 'Y'
                    when A.TaxCode = '4C'
                    then 'Y'
                    when A.TaxCode = '4D'
                    then 'Y'
                    when A.TaxCode = '4E'
                    then 'Y'
                    when A.TaxCode = '4F'
                    then 'Y'
                    when A.TaxCode = '4G'
                    then 'Y'
                    when A.TaxCode = '4H'
                    then 'Y' end                                                                as Supplyattractreverseharges,
         ''                                                                                     as Itemcode,
         'Y'                                                                                    as Category,
         '0.00'                                                                                 as SalepriceBeforediscount,
         '0.00'                                                                                 as Discount,
         '0.00'                                                                                 as Netsalepriceafterdiscount,
         '0.00'                                                                                 as Vat,
         '0.00'                                                                                 as CentralExcise,
         '0.00'                                                                                 as StateExcise,
         ''                                                                                     as Natureofexpense,
         ''                                                                                     as ShipFromState,
         ''                                                                                     as ShipToState,
         ''                                                                                     as WaybillNo,
         ''                                                                                     as Transportername,
         ''                                                                                     as LorryReceiptnumber,
         ''                                                                                     as LorryReceiptdate,
         ''                                                                                     as CDNoteOriginalInvoiceNo,
         ''                                                                                     as CDOriginalInvoiceDate,
         ''                                                                                     as ReasonforissuingDCNote,
         ''                                                                                     as AssessablevaluebeforeBCD,
         ''                                                                                     as BasicCustomDuty,
         ''                                                                                     as PortCode,
         ''                                                                                     as IsAdvanceAdjustment,
         ''                                                                                     as AdvanceadjustmentInvoiceNo,
         ''                                                                                     as AdvanceadjustmentInvoiceDate,
         ''                                                                                     as IsAmendment,
         ''                                                                                     as AmendmentOriginalYear,
         ''                                                                                     as AmendmentOriginalMonth,
         ''                                                                                     as AmendmentOriginalGSTINsupplier,
         ''                                                                                     as AmendmentOriginalDocumentNo,
         ''                                                                                     as AmendmentOriginalDocumentDate,
         ''                                                                                     as IsISD,
         ''                                                                                     as ISDLocationDetails,
         ''                                                                                     as vehicle,
         case
         when A.ConsumptionTaxCtrlCode = ''  or A.ConsumptionTaxCtrlCode is initial or
              A.ConsumptionTaxCtrlCode is null
         or A.TaxCode = '2A'
         or A.TaxCode = '2B'
         or A.TaxCode = '2C'
         or A.TaxCode = '2D'
         or A.TaxCode = '2E'
         or A.TaxCode = '2F'
         or A.TaxCode = '2G'
         or A.TaxCode = '2H'
         or A.TaxCode = '4A'
         or A.TaxCode = '4B'
         or A.TaxCode = '4C'
         or A.TaxCode = '4D'
         or A.TaxCode = '4E'
         or A.TaxCode = '4F'
         or A.TaxCode = '4G'
         or A.TaxCode = '4H'
         or A.TaxCode = '9A'

         then 'NO'
         when A.AccountingDocumentType = 'A'
         then 'CP'
         when A.taxcontrolcode = '99'
         then 'IS'
         else
         'IP'
         end                                                                                    as EligibilityofITC,
         cast(division( cast( A.Taxablevalue as abap.dec( 17,2 ) ) *
                        cast( A.CGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) ) as ITCCGSTAmt,
         cast(division( cast( A.Taxablevalue as abap.dec( 17,2 ) ) *
                        cast( A.SGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) ) as ITCSGSTAmt,
         cast(division( cast( A.Taxablevalue as abap.dec( 17,2 ) ) *
                        cast( A.IGSTRate as abap.dec( 17,2 ) ) , 100, 2 ) as abap.dec( 23,2 ) ) as ITCIGSTAmt,
         cast( A.CessValue as abap.dec( 23,2 ) )                                                as ITCCessAmt,
         @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
         A.AmountInTransactionCurrency                                                          as Taxableamount,
         case
                  when c.TaxNumber3 is  initial or
                       c.TaxNumber3 is  null  or
                       c.TaxNumber3 = ' '   then 'Un-Registered'
                 else
                 'Registered'
                  end                                                                           as Natureofsupply,
         case
                  when c.Region = 'OD'   then 'Inter-state'

                  else
                  'Intra-state'
                  end                                                                           as SupplyType


}
