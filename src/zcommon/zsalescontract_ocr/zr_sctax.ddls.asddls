@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSCTAX'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZR_SCTAX
  as select from zsc_tax
  association to parent ZR_SCHDR as _Header on $projection.Docuuid = _Header.Docuuid
{
  key docuuid as Docuuid,
  key tax_seq as TaxSeq,
  tax_id as TaxID,
  @Semantics.amount.currencyCode: 'Currency'
  taxable_amount as TaxableAmount,
  tax_percent as TaxPercent,
  @Semantics.amount.currencyCode: 'Currency'
  tax_amount as TaxAmount,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
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
  _Header
}
