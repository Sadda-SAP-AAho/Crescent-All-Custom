@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZSCITM'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_SCITM
  as projection on ZR_SCITM
  association [1..1] to ZR_SCITM as _BaseEntity on $projection.Docuuid = _BaseEntity.Docuuid and $projection.LineNumber = _BaseEntity.LineNumber
{
  key Docuuid,
  key LineNumber,
  ProductCode,
  Plant,
  PartNumber,
  Revision,
  ConditionType,
  Description,
  @Semantics: {
    quantity.unitOfMeasure: 'UOM'
  }
  OrderQty,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'UnitOfMeasure', 
      entity.name: 'I_UnitOfMeasureStdVH', 
      useForValidation: true
    } ]
  }
  UOM,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  UnitPrice,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  ExtPrice,
  DueDate,
  ShipByDate,
  TaxApplicable,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  Currency,
  LineAdded,
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
   _Header : redirected to parent ZC_SCHDR,
  _BaseEntity
}
