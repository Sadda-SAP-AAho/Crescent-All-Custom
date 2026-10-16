@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view : BRC item details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BRC
  as select from zdt_brc
  association to parent ZI_BRC_HEAD as _BrcHead on $projection.Id = _BrcHead.Id
{
  key   id                                    as Id,
  key   shippingbill                          as ShippingBill,
        cast( case when status = '1' then 'Uploaded'
                     when status = '2' then 'Success'
                     when status = '3' then 'Failed'
                     else 'Failed'
                     end as abap.char( 20 ) ) as Updstatus,
        cast( case when status = '1' then '2'
                     when status = '2' then '3'
                     when status = '3' then '1'
                     else '0'
                     end as abap.char( 1 ) ) as Criticality,
        brcno                                 as Brcno,
        brcdate                               as Brcdate,
        brcvalue                              as Brcvalue,
        status                                as Status,
        message                               as Message,
        _BrcHead

}
