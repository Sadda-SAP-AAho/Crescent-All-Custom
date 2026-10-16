@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Inv F4'
define view entity ZR_COMMINV_F4 
       as select distinct from I_BillingDocumentBasic as a
       left outer join I_BillingDocumentPartner as b on b.BillingDocument = a.BillingDocument 
                                                        and b.PartnerFunction = 'AG'
       left outer join I_Customer as c on b.Customer = c.Customer                                                        
{
    key a.BillingDocument,
        a.BillingDocumentType,
        a.BillingDocumentDate,
        b.Customer,
        c.CustomerFullName 
}
where a.BillingDocumentType = 'F2' or a.BillingDocumentType = 'L2'
