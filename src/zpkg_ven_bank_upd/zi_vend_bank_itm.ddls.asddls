@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Vend Bank Itm Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VEND_BANK_ITM as select from zdt_ven_bank_itm
association to parent ZI_VEND_BANK_HDR as _head on $projection.Id = _head.id
{    
   key id as Id,
   key supp as Supp,
   cast( case when status = '1' then 'Uploaded'
              when status = '2' then 'In Process'
              when status = '3' then 'Processed' 
              when status = '4' then 'Failed due to vendor'
              when status = '5' then 'Failed due to bank' end as abap.char( 20 ) )      as Updstatus,
      cast( case when ( status = '1' or status = '4' or status = '5' ) then '1'
                 when status = '2' then '2'
                 when status = '3' then '3' end as abap.char( 1 ) )               as Crcriticalitystatus, 
   suppname as Suppname,
   bankname as Bankname,
   bankacc as Bankacc,
   bankcou as Bankcou,
   bankkey as Bankkey,
   status  as Status,
   _head
}
