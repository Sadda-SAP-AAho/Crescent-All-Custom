@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Invoice F4'
define root view entity ZCDS_INV_F4 as 
select distinct from I_BillingDocument as a
left outer join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument

{
    key a.BillingDocument,
    key a.BillingDocumentDate
    
}
where ( ( a.BillingDocumentType = 'F8' and  b.ReferenceSDDocumentCategory = 'J') 
   or ( a.BillingDocumentType = 'F2' and ( b.Division = 'PT' or b.Division = 'AS' or 
        b.MaterialGroup = 'Z001' or b.MaterialGroup = 'Z002' or b.MaterialGroup = 'Z035' or
        b.SDDocumentReason = 'Z01' or b.SDDocumentReason = 'Z06' ) ) ) 
 
