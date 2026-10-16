@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSCHDR'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_SCHDR
  as select from zsc_hdr
  composition [0..*] of ZR_SCITM as _Items
  composition [0..*] of ZR_SCTAX as _Taxes
{
  key docuuid as Docuuid,
  po_number as PoNumber,
  so_number as SoNumber,
  airfaas_order_id as AirfaasOrderID,
  account_reference as AccountReference,
  order_date as OrderDate,
  due_date as DueDate,
  revision_date as RevisionDate,
  is_change_order as IsChangeOrder,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  customer_code as CustomerCode,
  customer_name as CustomerName,
  customer_addr_line1 as CustomerAddrLine1,
  customer_addr_line2 as CustomerAddrLine2,
  customer_city as CustomerCity,
  customer_state as CustomerState,
  customer_postal as CustomerPostal,
  customer_country as CustomerCountry,
  customer_phone as CustomerPhone,
  customer_fax as CustomerFax,
  customer_email as CustomerEmail,
  customer_vat_id as CustomerVatID,
  customer_eori_no as CustomerEoriNo,
  customer_company_no as CustomerCompanyNo,
  salesorganization as SalesOrganization,
  distributionchannel as DistributionChannel,
  division as Division,
  vendor_name as VendorName,
  vendor_addr_line1 as VendorAddrLine1,
  vendor_addr_line2 as VendorAddrLine2,
  vendor_city as VendorCity,
  vendor_state as VendorState,
  vendor_postal as VendorPostal,
  vendor_country as VendorCountry,
  vendor_phone as VendorPhone,
  vendor_fax as VendorFax,
  vendor_vat_id as VendorVatID,
  ship_to_name as ShipToName,
  ship_to_addr_line1 as ShipToAddrLine1,
  ship_to_addr_line2 as ShipToAddrLine2,
  ship_to_city as ShipToCity,
  ship_to_state as ShipToState,
  ship_to_postal as ShipToPostal,
  ship_to_country as ShipToCountry,
  ship_from_name as ShipFromName,
  ship_from_addr_line1 as ShipFromAddrLine1,
  ship_from_addr_line2 as ShipFromAddrLine2,
  ship_from_city as ShipFromCity,
  ship_from_postal as ShipFromPostal,
  ship_from_country as ShipFromCountry,
  ship_via as ShipVia,
  incoterms as Incoterms,
  incoterms_year as IncotermsYear,
  pol as Pol,
  pod as Pod,
  prepaid_freight as PrepaidFreight,
  payment_terms as PaymentTerms,
  delivery_terms as DeliveryTerms,
  buyer_name as BuyerName,
  buyer_department as BuyerDepartment,
  buyer_email as BuyerEmail,
  invoice_email as InvoiceEmail,
  @Semantics.amount.currencyCode: 'Currency'
  lines_subtotal as LinesSubtotal,
  @Semantics.amount.currencyCode: 'Currency'
  misc_charge as MiscCharge,
  @Semantics.amount.currencyCode: 'Currency'
  tax_subtotal as TaxSubtotal,
  @Semantics.amount.currencyCode: 'Currency'
  total as Total,
  po_comment as PoComment,
  so_comment as SoComment,
  notes as Notes,
  authorized_by as AuthorizedBy,
  terms_url as TermsUrl,
  file_name as FileName,
  provider as Provider,
  posted_by as PostedBy,
  posted_at as PostedAt,
  status as Status,
  error_log as ErrorLog,
  is_posted_sap as IsPostedSap,
  sales_contract as SalesContract,
  is_contract_sent as IsContractSent,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  changed_by as ChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  changed_at as ChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_changed_at as LocalChangedAt,
  _Items,
  _Taxes
}
