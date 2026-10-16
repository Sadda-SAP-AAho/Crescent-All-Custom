@EndUserText.label: 'Interface View for Packing List Header'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_PACKLIST_HDR
  as select from zdt_packlist_hdr
  composition [0..*] of ZI_PACKLIST_ITM as _Item
{
  key id           as Id,
      packinglist  as Packinglist,
      revision     as Revision,
      delivery     as Delivery,
      salesorg     as Salesorg,
      plant        as Plant,
      createdby    as Createdby,
      createdon    as Createdon,
      createdat    as Createdat,
      changeddby   as Changeddby,
      changedon    as Changedon,
      changedat    as Changedat,
      canind       as Canind,
      cancelby     as Cancelby,
      cancelon     as Cancelon,
      status       as Status,
      cancel       as Cancel,
      prnt         as Prnt,
      dprint       as Dprint,
      domprint     as Domprint,
      domprinthsn as Domprinthsn,
      xportprinthsn as Xportprinthsn,
      zstatus      as Zstatus,
      contactp     as Contactp,
      contactn     as Contactn,
      pkgtyp       as Pkgtyp,
      customercode as Customercode,
      customername as Customername,
      remarks      as Remarks,
      _Item
}
