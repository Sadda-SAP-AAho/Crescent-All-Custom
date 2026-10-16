@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer View Help'
@UI.presentationVariant: [{ sortOrder: [{ by: 'DeliveryDocument', direction: #DESC }] }]
define view entity ZCDS_EXLCDLV_F4
  as select distinct from I_DeliveryDocument     as a
    inner join            I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
    inner join            I_SalesOrder           as c on b.ReferenceSDDocument = c.SalesOrder


{
      @EndUserText.label: 'DeliveryNo'
  key a.DeliveryDocument     as DeliveryDocument,
      @EndUserText.label: 'Customer'
  key a.SoldToParty          as SoldToParty,
      @EndUserText.label: 'SO No'
  key b.ReferenceSDDocument  as ReferenceSDDocument,
      @EndUserText.label: 'Payment Terms'
  key c.CustomerPaymentTerms as CustomerPaymentTerms,
      @EndUserText.label: 'Company Code'
  key c.BillingCompanyCode   as BillingCompanyCode
}
where
  a.DeletionIndicator = ''
