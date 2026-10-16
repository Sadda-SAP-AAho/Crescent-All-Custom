@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for credit Note Doc No.-SD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_CDNT_F4
  as select from    I_BillingDocument     as a
    left outer join ZSD_SALES_CDN_BILL_TO as c on a.BillingDocument = c.BillingDocument
{
  key a.BillingDocument     as document_no,
//      a.SalesOrganization   as SLS_ORG,         /*Commented by IC 26.05.26*/
      a.CompanyCode         as Company_Code,
      a.BillingDocumentDate as document_date
//      c.Customer            as Payer            /*Commented by IC 26.05.26*/ 
}
where
      a.CompanyCode = '1000'
  and ( a.BillingDocumentType = 'G2'
     or a.BillingDocumentType = 'L2'
     or a.BillingDocumentType = 'CBRE' ) 
