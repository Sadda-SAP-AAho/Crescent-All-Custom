@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Customer data with Pricing Procedure'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_CUST_PRI_PRO
  provider contract transactional_query
  as projection on ZI_CUST_PRI_PRO
{
        
         @EndUserText.label: 'Customer Code'
  key    Customer,
         @UI.hidden: true
  key    SalesOrganization,
         @UI.hidden: true
  key    DistributionChannel,
         @UI.hidden: true
  key    Division,
         @UI.hidden: true
  key    PartnerCounter,
         @UI.hidden: true
  key    CustomerPartnerFunction,
         @EndUserText.label: 'Customer Name'
         CustomerName,
         @EndUserText.label: 'Customer Bill To Address'
         BillToParty,
         @EndUserText.label: 'Customer Ship To Address'
         ShipToParty,
         @EndUserText.label: 'Inco Info'
         IncoTerms,
         @EndUserText.label: 'Inco Terms Description'
         IncoTermsDescription,
         @EndUserText.label: 'Payment Terms'
         PaymentTerms,
         @EndUserText.label: 'Payment Terms Description'
         PaymentTermsDescription,
         @EndUserText.label: 'Pricing Code'
         PricingCode,
         @EndUserText.label: 'Pricing Description'
         PricingDescription,
         @EndUserText.label: 'Currency'
         Currency,
         @EndUserText.label: 'Customer Account Group'
         CustomerAccountGroup,
         @EndUserText.label: 'Account Group Description'
         AccountGroupName,
         @EndUserText.label: 'Bank Name'
         BankName
}
