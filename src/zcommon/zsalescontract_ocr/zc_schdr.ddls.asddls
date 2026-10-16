@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZSCHDR'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_SCHDR
  provider contract transactional_query
  as projection on ZR_SCHDR
  association [1..1] to ZR_SCHDR as _BaseEntity on $projection.Docuuid = _BaseEntity.Docuuid
{
  key Docuuid,
  PoNumber,
  SoNumber,
  AirfaasOrderID,
  AccountReference,
  OrderDate,
  DueDate,
  RevisionDate,
  IsChangeOrder,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  Currency,
  CustomerCode,
  CustomerName,
  CustomerAddrLine1,
  CustomerAddrLine2,
  CustomerCity,
  CustomerState,
  CustomerPostal,
  CustomerCountry,
  CustomerPhone,
  CustomerFax,
  CustomerEmail,
  CustomerVatID,
  CustomerEoriNo,
  CustomerCompanyNo,
  DistributionChannel,
  Division,
  SalesOrganization,
  VendorName,
  VendorAddrLine1,
  VendorAddrLine2,
  VendorCity,
  VendorState,
  VendorPostal,
  VendorCountry,
  VendorPhone,
  VendorFax,
  VendorVatID,
  ShipToName,
  ShipToAddrLine1,
  ShipToAddrLine2,
  ShipToCity,
  ShipToState,
  ShipToPostal,
  ShipToCountry,
  ShipFromName,
  ShipFromAddrLine1,
  ShipFromAddrLine2,
  ShipFromCity,
  ShipFromPostal,
  ShipFromCountry,
  ShipVia,
  Incoterms,
  IncotermsYear,
  Pol,
  Pod,
  PrepaidFreight,
  PaymentTerms,
  DeliveryTerms,
  BuyerName,
  BuyerDepartment,
  BuyerEmail,
  InvoiceEmail,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  LinesSubtotal,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  MiscCharge,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  TaxSubtotal,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  Total,
  PoComment,
  SoComment,
  Notes,
  AuthorizedBy,
  TermsUrl,
  FileName,
  Provider,
  PostedBy,
  PostedAt,
  Status,
  ErrorLog,
  IsPostedSap,
  SalesContract,
  IsContractSent,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
  @Semantics: {
    user.lastChangedBy: true
  }
  ChangedBy,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  ChangedAt,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalChangedAt,
  _Items: redirected to composition child ZC_SCITM,
  _Taxes: redirected to composition child ZC_SCTAX,
  _BaseEntity
}
