@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Additional'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCOMMADD

  as select from zexim_comm_add

  association to parent ZI_EXIMCOMMHDR as _head on $projection.Id = _head.Id

{
  key id              as Id,
  key item            as Item,
      paymenttext     as Paymenttext,
      invoiceremarks1 as Invoiceremarks1,
      invoiceremarks2 as Invoiceremarks2,
      invoiceremarks3 as Invoiceremarks3,
      taxremarks      as Taxremarks,
      materialdesc1   as Materialdesc1,
      materialdesc2   as Materialdesc2,
      materialdesc3   as Materialdesc3,

      _head
}
