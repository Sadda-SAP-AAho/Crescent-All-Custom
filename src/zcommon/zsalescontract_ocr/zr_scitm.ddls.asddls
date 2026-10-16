@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSCITM'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZR_SCITM
  as select from zsc_itm
  association to parent ZR_SCHDR as _Header on $projection.Docuuid = _Header.Docuuid
{
  key docuuid as Docuuid,
  key line_number as LineNumber,
  product_code as ProductCode,
  plant as Plant,
  part_number as PartNumber,
  revision as Revision,
  condition_type as ConditionType,
  description as Description,
  @Semantics.quantity.unitOfMeasure: 'UOM'
  order_qty as OrderQty,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  uom as UOM,
  @Semantics.amount.currencyCode: 'Currency'
  unit_price as UnitPrice,
  @Semantics.amount.currencyCode: 'Currency'
  ext_price as ExtPrice,
  due_date as DueDate,
  ship_by_date as ShipByDate,
  tax_applicable as TaxApplicable,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  line_added as LineAdded,
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
