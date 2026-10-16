@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZSCTAX'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define  view entity ZC_SCTAX
  as projection on ZR_SCTAX
  association [1..1] to ZR_SCTAX as _BaseEntity on $projection.Docuuid = _BaseEntity.Docuuid and $projection.TaxSeq = _BaseEntity.TaxSeq
{
  key Docuuid,
  key TaxSeq,
  TaxID,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  TaxableAmount,
  TaxPercent,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  TaxAmount,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  Currency,
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
