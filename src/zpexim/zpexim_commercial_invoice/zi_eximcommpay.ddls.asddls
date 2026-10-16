@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Payment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCOMMPAY

  as select from zexim_comm_pay

  association to parent ZI_EXIMCOMMHDR as _head on $projection.Id = _head.Id

{
  key id               as Id,
  key item             as Item,
      paymentterms     as Paymentterms,
      paymenttermsdesc as Paymenttermsdesc,
      bankname         as Bankname,
      bankaccountno    as Bankaccountno,
      bankifsc         as Bankifsc,
      bankswift        as Bankswift,
      bankaddress      as Bankaddress,
      issuingbank      as Issuingbank,
      negotiatingbank  as Negotiatingbank,
      lcnumber         as Lcnumber,
      lutarnno         as Lutarnno,
      lutarndate       as Lutarndate,
      adcode           as Adcode,

      _head

}
