@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Container Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCOMMCNH

  as select from zexim_comm_cnh

  association to parent ZI_EXIMCOMMHDR as _head on $projection.Id = _head.Id

{
  key id                  as Id,
  key item                as Item,
      authorizedperson    as Authorizedperson,
      contactno           as Contactno,
      designation         as Designation,
      weighbridgeno       as Weighbridgeno,
      weighbridgeslipno   as Weighbridgeslipno,
      weighbridgedatein   as Weighbridgedatein,
      weighbridgetimein   as Weighbridgetimein,
      weighbridgedateout  as Weighbridgedateout,
      weighbridgetimeout  as Weighbridgetimeout,
      maxpermitweight     as Maxpermitweight,
      bookingno           as Bookingno,
      color               as Color,
      exstuffingstartdate as Exstuffingstartdate,
      exstuffingstarttime as Exstuffingstarttime,
      exstuffingenddate   as Exstuffingenddate,
      exstuffingendtime   as Exstuffingendtime,
      exstuffingtotaltime as Exstuffingtotaltime,
      shipperregno        as Shipperregno,

      _head
}
