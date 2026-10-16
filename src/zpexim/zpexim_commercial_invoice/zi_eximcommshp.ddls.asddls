@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Shipment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCOMMSHP

  as select from zexim_comm_shp

  association to parent ZI_EXIMCOMMHDR as _head on $projection.Id = _head.Id
{
  key id                  as Id,
  key item                as Item,
      finaldest           as Finaldest,
      incoterms           as Incoterms,
      incotermsl          as Incotermsl,
      portofloading       as Portofloading,
      portofdischarge     as Portofdischarge,
      vesselflight        as Vesselflight,
      insuranceno         as Insuranceno,
      blno                as Blno,
      bldate              as Bldate,
      broker              as Broker,
      egm                 as Egm,
      egmdate             as Egmdate,
      commission          as Commission,
      shippingline        as Shippingline,
      sailingdate         as Sailingdate,
      dispatchfrom        as Dispatchfrom,
      dispatchto          as Dispatchto,
      countryorigin       as Countryorigin,
      countrydestination  as Countrydestination,
      termsofdelivery     as Termsofdelivery,
      actualdatearrival   as Actualdatearrival,
      expecteddatearrival as Expecteddatearrival,
      pino                as Pino,
      pidate              as Pidate,
      dispatchno          as Dispatchno,
      dispatchdate        as Dispatchdate,

      _head
}
