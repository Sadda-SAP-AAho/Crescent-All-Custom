@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PAYMENT_HEAD
  as select distinct from ZV_PAYMENT_HEAD  as a
    left outer join       zdt_payment_head as c on  c.accountingdoc = a.Accountingdoc
                                                and c.fiscalyear    = a.Fiscalyear
                                                and c.companycode   = a.Companycode
                                                
                                              
 
    left outer join       I_Supplier       as d on d.Supplier = a.Supplier
  composition [0..*] of zi_invoicE_item as _item
  composition [0..*] of ZI_APPR_LOG     as _item1
{
  key    a.Accountingdoc                                    as Accountingdoc,
  key    a.Fiscalyear                                       as Fiscalyear,
  key    a.Companycode                                      as Companycode,
     a.PaymentRunID,                                  
         a.DocumentDate,
         a.PostingDate,
         a.ValueDate,
         a.Supplier,
         d.SupplierName,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         a.AmountInCompanyCodeCurrency,
         a.CompanyCodeCurrency,
         a.PaymentMethod,
         a.HouseBank,
         a.HouseBankAccount,
         a.BankAccountNumber,
         a.PayeeBankAccount,
         a.PayeeBankKey,
         a.apprlevel,
         a.Appr1comment,
         a.Appr2comment,
         a.Status,
         case  when a.Status = 'In Approval'   then 2
              when a.Status = 'UTR Generated'   then 3
              when a.Status = 'Failed'   then 1
              when a.Status = 'Rejected' then 1
              when a.Status = 'Sent to Bank' then 2
              when a.Status = 'Approved' then 2
              else 3 end                                    as Criticality,
         a.Senton,
         a.Sentat,
         a.Sentby,
         a.Utr,
         a.Message,
         a.Messagecode,
         a.Approved,
         a.Rejected,
         a.Inprocess,
         a.Appr1,
         a.Senthsbc,
         a.Appr2,
         a.Appr3,
         a.Reject1,
         a.Reject2,
         a.Reject3,
         a.Filename,
         a.Counter,
         c.delete_ind, //Deletion indicator
         case when c.delete_ind = 'X' then 'X' else 'Y' end as del_val,
         _item,
         _item1
}
where
  a.Supplier is not initial ;
//and c.delete_ind = ''
