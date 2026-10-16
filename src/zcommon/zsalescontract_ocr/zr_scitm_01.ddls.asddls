@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Resource View for ZSC_ITM'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_SCITM_01 as select from zsc_itm
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
    uom as Uom,
  @Semantics.amount.currencyCode: 'Currency'
    unit_price as UnitPrice,
  @Semantics.amount.currencyCode: 'Currency'
    ext_price as ExtPrice,
    due_date as DueDate,
    ship_by_date as ShipByDate,
    tax_applicable as TaxApplicable,
    line_added as LineAdded,
    currency as Currency,
    created_by as CreatedBy,
    created_at as CreatedAt,
    changed_by as ChangedBy,
    changed_at as ChangedAt,
    local_changed_at as LocalChangedAt
}
