@AbapCatalog.sqlViewName: 'ZSALESCONTHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Sales Contract Header'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALESCONTHEAD
  as select distinct from I_SalesContract     as a
    left outer join       I_PaymentTermsText  as b on  a.CustomerPaymentTerms = b.PaymentTerms
                                                   and b.Language             = 'E'
    left outer join       ztmg_salesgrp       as c on  a.SalesGroup            = c.salesgroup
                                                   and c.configdeprecationcode is initial
    left outer join       I_SalesDocument     as d on d.SalesDocument = a.SalesContract
    left outer join       zdt_mpod_tmg        as e on e.podcode = d.YY1_PortofDischarge1_SDH
    left outer join       I_BusinessUserBasic as f on f.UserID = a.CreatedByUser
{
  key a.SalesContract                  as Sales_Cont_No,
      a.SalesContractDate              as Sales_Cont_Dt,
      a.SalesContractValidityStartDate as Valid_From,
      a.SalesContractValidityEndDate   as Valid_To,
      f.PersonFullName                 as CreatedBy,
      a.CreationDate                   as CreateDate,
      a.PurchaseOrderByCustomer        as Cust_PO_No,
      a.CustomerPurchaseOrderDate      as Cust_PO_Dt,
      a.SoldToParty                    as Cust_Code,
      b.PaymentTermsName               as PayTerm,
      a.IncotermsClassification        as Del_Term,
      c.salesperson                    as Sales_Person,
      e.podcodename                    as Port_of_Discharge,
      d.YY1_POEntryMailRecdDat_SDH     as PO_Entry_Mail_Recd_Dt,
      d.YY1_SOTransferMailRecd_SDH     as SO_Transfer_Mail_Recd_Dt 
      

}
