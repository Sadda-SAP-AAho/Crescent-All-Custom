@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Head Filtered'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_bank_stat_head_filtered
  as select from ZI_bank_stat_head as Head
    left outer join ZI_bank_stat_supplier_tot as Tot
      on  Head.Bankaccountnumber = Tot.Bankaccountnumber
      and Head.Supplier          = Tot.Supplier
{
  key Head.Accountingdoc               as PaymentDocNumber,
  key Head.Fiscalyear                  as FiscalYear,
  key Head.Companycode                 as CompanyCode,

      Head.Postingdate                 as PostingDate,
      Head.Payeebankaccount            as VendorBankAccount,
      Head.Payeebankkey                as VendorIFSC,
      Head.Supplier                    as Supplier,

      @Semantics.amount.currencyCode: 'Currency'
      Head.Amountincompanycodecurrency as PaymentAmount,

      Head.Companycodecurrency         as Currency,
      Head.Housebank                   as HouseBank,
      Head.Bankaccountnumber           as OwnBankAccountNumber,
      Head.suppliername                as SupplierName,
      Head.Status                      as Status,
      Head.Utr                         as UTR
}
where
      Head.Postingdate       = $session.system_date        -- CDS equivalent of sy-datum
  and (     cast( Head.Bankaccountnumber as abap.int8 ) = 31251000015
         or cast( Head.Bankaccountnumber as abap.int8 ) = 341233011 )
  and (
        -- Bank account 031251000015
        (     cast( Head.Bankaccountnumber as abap.int8 ) = 31251000015
          and abs( cast( Head.Amountincompanycodecurrency as abap.dec( 23, 2 ) ) ) <= 1000000
          and abs( Tot.SupplierTotalAmount )                                       > 1000000 )

     or
        -- Bank account 0341233011
        (     cast( Head.Bankaccountnumber as abap.int8 ) = 341233011
          and abs( Tot.SupplierTotalAmount ) > 1000000 )
      )
