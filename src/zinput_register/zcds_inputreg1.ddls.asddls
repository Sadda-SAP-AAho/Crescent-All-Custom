@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG1
  as select distinct from ZCDS_INPUTREG4           as gg
////  as select distinct from ZR_INPUTREGN_1           as gg
    inner join            I_JournalEntryItem       as a   on  gg.SourceLedger        = a.SourceLedger
                                                          and gg.CompanyCode         = a.CompanyCode
                                                          and gg.FiscalYear          = a.FiscalYear
                                                          and gg.AccountingDocument  = a.AccountingDocument
                                                          and gg.Ledger              = a.Ledger
                                                          and gg.GLAccount           = a.GLAccount
                                                          and gg.TaxCode             = a.TaxCode
                                                          and gg.TransactionCurrency = a.TransactionCurrency
                                                          and gg.LedgerGLLineItema   = a.LedgerGLLineItem

    inner join            I_CompanyCode            as b   on b.CompanyCode = a.CompanyCode
  ////    inner join            ztmg_reg                 as g   on g.glaccount = a.GLAccount
    left outer join       I_Supplier               as c   on c.Supplier = a.Supplier
    left outer join       I_RegionText             as d   on  d.Country  = c.Country
                                                          and d.Region   = c.Region
                                                          and d.Language = $session.system_language
    left outer join       I_ProductDescription     as e   on  e.Product  = a.Product
                                                          and e.Language = $session.system_language
    left outer join       I_Product                as ee  on ee.Product = a.Product
    left outer join       I_GLAccountText          as Z   on  Z.GLAccount       = a.GLAccount
                                                          and Z.Language        = $session.system_language
                                                          and Z.ChartOfAccounts = 'YCOA'
    left outer join       I_ProductPlantBasic      as f   on(
        f.Product   = e.Product
        and f.Plant = a.Plant
      )
    left outer join       ZCDS_INPUTREG9           as gh  on(
       gh.AccountingDocument         = a.AccountingDocument
       and gh.CompanyCode            = a.CompanyCode
       and gh.FiscalYear             = a.FiscalYear
       and gh.AccountingDocumentItem = a.AccountingDocumentItem
     )
    left outer join       ZCDS_INPUTREG5           as gg1 on  gg1.CompanyCode        = a.CompanyCode
                                                          and gg1.FiscalYear         = a.FiscalYear
                                                          and gg1.AccountingDocument = a.AccountingDocument
    left outer join       ZR_PRODHSN               as zz  on  zz.AccountingDocument = a.AccountingDocument
                                                          and zz.CompanyCode        = a.CompanyCode
                                                          and zz.FiscalYear         = a.FiscalYear
    left outer join       I_PurchaseOrderItemAPI01 as zz1 on  zz1.PurchaseOrder     = a.PurchasingDocument
                                                          and zz1.PurchaseOrderItem = a.PurchasingDocumentItem
    left outer join       ZR_INPUTREG13            as ghi on(
      ghi.AccountingDocument = a.AccountingDocument
      and ghi.CompanyCode    = a.CompanyCode
      and ghi.FiscalYear     = a.FiscalYear
    )
{
  key   a.SourceLedger,
  key   a.CompanyCode,
  key   a.FiscalYear,
  key   a.AccountingDocument,
  key   a.LedgerGLLineItem,
  key   a.Ledger,
        a.BusinessArea,
        b.CompanyCodeName,
        a.ProfitCenter,
        a.Segment,
        gg1.Plant,
        a.DocumentDate,
        a.TransactionCurrency,
        a.GLAccount,
        Z.GLAccountName,
        a.AccountingDocumentType,

        case when gg.GLAccount = '0000251013'  and gg.TaxCode =  '1E'
        then 'DEL'
        when gg.GLAccount = '0000251003'  and ( gg.TaxCode =  '2A' or gg.TaxCode =  '2D'
                                                or gg.TaxCode =  '2B' or gg.TaxCode =  '2C'
                                                or gg.TaxCode =  '2E' or gg.TaxCode =  '2F'
                                                or gg.TaxCode =  '2G' or gg.TaxCode =  '2H' )
        then 'DEL'
        when gg.GLAccount = '0000251006'  and ( gg.TaxCode =  '2A' or gg.TaxCode =  '2D'
                                                or gg.TaxCode =  '2B' or gg.TaxCode =  '2C'
                                                or gg.TaxCode =  '2E' or gg.TaxCode =  '2F'
                                                or gg.TaxCode =  '2G' or gg.TaxCode =  '2H' )
        then 'DEL'
        when gg.GLAccount = '0000476006'  and ( gg.TaxCode =  '2A' or gg.TaxCode =  '2D'
                                                or gg.TaxCode =  '2B' or gg.TaxCode =  '2C'
                                                or gg.TaxCode =  '2E' or gg.TaxCode =  '2F'
                                                or gg.TaxCode =  '2G' or gg.TaxCode =  '2H' )
        then 'DEL'
        when gg.GLAccount = '0000476005'  and ( gg.TaxCode =  '2A' or gg.TaxCode =  '2D'
                                                or gg.TaxCode =  '2B' or gg.TaxCode =  '2C'
                                                or gg.TaxCode =  '2E' or gg.TaxCode =  '2F'
                                                or gg.TaxCode =  '2G' or gg.TaxCode =  '2H' )
        then 'DEL'
        when gg.GLAccount = '0000251012'  and ( gg.TaxCode =  '7A' or gg.TaxCode =  '7E' )
        then 'DEL'
        when gg.GLAccount = '0000251013'  and ( gg.TaxCode =  '7A' or gg.TaxCode =  '7E' )
        then 'DEL'
        else
        'Odisha'         end                                                   as State,
        case when a.CompanyCode  = '1000'
        then '21AADCM2818E1Z1'
        when a.CompanyCode  = '2000'
        then '21AABCW7542H1ZG'
        when a.CompanyCode  = '3000'
        then '21AAOCM3055E1ZR'
        when a.CompanyCode  = '4000'
        then '21AALCP9810F1ZI'
        when a.CompanyCode  = '5000'
        then '21AACCW9530E1ZL'
        when a.CompanyCode  = '6000'
        then '21AAOCM5746N1ZY'  end                                            as GSTIN,
        '1'                                                                    as TransactionCount,
        c.Supplier,
        c.SupplierFullName,
        c.TaxNumber3,
        d.RegionName,
        e.ProductDescription,
        case when gh.IN_HSNOrSACCode is not null or gh.IN_HSNOrSACCode is not initial or
        gh.IN_HSNOrSACCode != ''
        then gh.IN_HSNOrSACCode
        else
        f.ConsumptionTaxCtrlCode end                                           as ConsumptionTaxCtrlCode,
        a.BaseUnit,
        @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
        zz.QuantityInEntryUnit                                                 as quantity,
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        case  when ghi.GLAccount = 0
         and ( a.TaxCode = '7E' or a.TaxCode = '7A' )//( a.TaxCode = '7E' or a.TaxCode = '7A' ) and zz1.TaxCode = a.TaxCode
            then case when a.AccountingDocumentType = 'RE' and gg.AmountInTransactionCurrency < 0
                      then cast(    gg.AmountInTransactionCurrency as abap.dec( 23,2 ) ) -  ( -1 * cast(         zz.QuantityInEntryUnit * 400                  as abap.dec( 23,2 ) ) )
                    else
              cast(    gg.AmountInTransactionCurrency as abap.dec( 23,2 ) ) -  cast(         zz.QuantityInEntryUnit * 400                  as abap.dec( 23,2 ) ) end
        else
        cast( gg.AmountInTransactionCurrency as abap.dec( 23,2 ) )         end as AmountInTransactionCurrency,
        a.DocumentItemText,
        a.PostingDate,
        'Odisha'                                                               as Pos,
        a.ReferenceQuantityUnit,
        a.TaxCode,
        case
             when a.TaxCode = '1E' then division( 5, 2, 1 )
             when a.TaxCode = '1F' then 6
             when a.TaxCode = '1G' then 9
             when a.TaxCode = '1H' then 14
             when a.TaxCode = '2E' then division( 5, 2, 1 )
             when a.TaxCode = '2F' then 6
             when a.TaxCode = '2G' then 9
             when a.TaxCode = '2H' then 14
             when a.TaxCode = '3E' then division( 5, 2, 1 )
             when a.TaxCode = '3F' then 6
             when a.TaxCode = '3G' then 9
             when a.TaxCode = '3H' then 14
             when a.TaxCode = '4E' then division( 5, 2, 1 )
             when a.TaxCode = '4F' then 6
             when a.TaxCode = '4G' then 9
             when a.TaxCode = '4H' then 14
             when a.TaxCode = '5E' then division( 5, 2, 1 )
             when a.TaxCode = '5F' then 6
             when a.TaxCode = '5G' then 9
             when a.TaxCode = '5H' then 14
             when a.TaxCode = '6G' then 9
             when a.TaxCode = 'A0' then division( 1, 10, 1 )
             when a.TaxCode = 'B0' then division( 1, 10, 1 )

             when a.TaxCode = '7C' then division( 5, 2, 1 )
             when a.TaxCode = '7D' then division( 5, 2, 1 )
             when a.TaxCode = '7E' then division( 5, 2, 1 )
             else 0
             end                                                               as CGSTRate,

        case
        when a.TaxCode = '1E' then division( 5, 2, 1 )
        when a.TaxCode = '1F' then 6
        when a.TaxCode = '1G' then 9
        when a.TaxCode = '1H' then 14
        when a.TaxCode = '2E' then division( 5, 2, 1 )
        when a.TaxCode = '2F' then 6
        when a.TaxCode = '2G' then 9
        when a.TaxCode = '2H' then 14
        when a.TaxCode = '3E' then division( 5, 2, 1 )
        when a.TaxCode = '3F' then 6
        when a.TaxCode = '3G' then 9
        when a.TaxCode = '3H' then 14
        when a.TaxCode = '4E' then division( 5, 2, 1 )
        when a.TaxCode = '4F' then 6
        when a.TaxCode = '4G' then 9
        when a.TaxCode = '4H' then 14
        when a.TaxCode = '5E' then division( 5, 2, 1 )
        when a.TaxCode = '5F' then 6
        when a.TaxCode = '5G' then 9
        when a.TaxCode = '5H' then 14
        when a.TaxCode = '6G' then 9
        when a.TaxCode = 'A0' then division( 1, 10, 1 )
        when a.TaxCode = 'B0' then division( 1, 10, 1 )

         when a.TaxCode = '7C' then division( 5, 2, 1 )
             when a.TaxCode = '7D' then division( 5, 2, 1 )
             when a.TaxCode = '7E' then division( 5, 2, 1 )

        else 0
        end                                                                    as SGSTRate,

        case
        when a.TaxCode = '1A' then 5
        when a.TaxCode = '1B' then 12
        when a.TaxCode = '1C' then 18
        when a.TaxCode = '1D' then 28
        when a.TaxCode = '1I' then 28
        when a.TaxCode = '2A' then 5
        when a.TaxCode = '2B' then 12
        when a.TaxCode = '2C' then 18
        when a.TaxCode = '2D' then 28
        when a.TaxCode = '2I' then 0
        when a.TaxCode = '3A' then 5
        when a.TaxCode = '3B' then 12
        when a.TaxCode = '3C' then 18
        when a.TaxCode = '3D' then 28
        when a.TaxCode = '4A' then 5
        when a.TaxCode = '4B' then 12
        when a.TaxCode = '4C' then 18
        when a.TaxCode = '4D' then 28
        when a.TaxCode = '5A' then 5
        when a.TaxCode = '5B' then 12
        when a.TaxCode = '5C' then 18
        when a.TaxCode = '5D' then 28
        when a.TaxCode = '7A' then 5
        when a.TaxCode = '7B' then 12
        else 0
        end                                                                    as IGSTRate,
        case
        when a.TaxCode = '1I' then 28
        when a.TaxCode = '2I' then 22
        else 0
        end                                                                    as Cess,
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }

        gg.AmountInTransactionCurrency                                         as Taxablevalue,
        ee.ProductGroup,
        case  when ghi.GLAccount = 0
        and ( a.TaxCode = '7E' or a.TaxCode = '7A' )

        then case when a.AccountingDocumentType = 'RE' and gg.AmountInTransactionCurrency < 0
                      then cast(    gg.AmountInTransactionCurrency as abap.dec( 23,2 ) ) -  ( -1 * cast(         zz.QuantityInEntryUnit * 400                  as abap.dec( 23,2 ) ) )
                    else
              cast(    gg.AmountInTransactionCurrency as abap.dec( 23,2 ) ) -  cast(         zz.QuantityInEntryUnit * 400                  as abap.dec( 23,2 ) ) end
        //cast(    gg.AmountInTransactionCurrency as abap.dec( 23,2 ) ) -  cast(         zz.QuantityInEntryUnit * 400                  as abap.dec( 23,2 ) )

        else
        cast(    gg.AmountInTransactionCurrency as abap.dec( 23,2 ) ) end      as taxval



}
where
       a.SourceLedger           = '0L'
  and  a.Ledger                 = '0L'
  and(
       a.AccountingDocumentType = 'KR'
    or a.AccountingDocumentType = 'RE'
    or a.AccountingDocumentType = 'KG'
    or a.AccountingDocumentType = 'KA'
    or a.AccountingDocumentType = 'SA'
    or a.AccountingDocumentType = 'AB'
    or a.AccountingDocumentType = 'KH'
    or a.AccountingDocumentType = 'ZL'
    or a.AccountingDocumentType = 'AD'
    or a.AccountingDocumentType = 'V0'

    or a.AccountingDocumentType = 'SK'
  )
  and  a.TaxCode                is not initial
//  and(
//       a.GLAccount              like '000048%'
//    or a.GLAccount              like '000024%'
//    or a.GLAccount              like '000013%'
//  )
// ( a.GLAccount <> '0000258003' and a.GLAccount <> '0000258007' and a.GLAccount <> '0000137017' and a.GLAccount <> '0000258004' and a.GLAccount <> '0000258008'
//and a.GLAccount <> '0000258002' and a.GLAccount <> '0000258006' )
