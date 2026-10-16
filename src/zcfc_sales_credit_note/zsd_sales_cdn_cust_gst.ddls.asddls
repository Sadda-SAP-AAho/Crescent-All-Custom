@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer GST No'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_SALES_CDN_CUST_GST 
as select from I_BillingDocument as a
left outer join I_BillingDocumentPartner as b
on a.BillingDocument = b.BillingDocument
left outer join I_Businesspartnertaxnumber as c
on b.Customer = c.BusinessPartner

{

key a.BillingDocument,
key b.Customer,
    c.BPTaxNumber
    
}

where b.PartnerFunction = 'RE'
and c.BPTaxType = 'IN3' 
