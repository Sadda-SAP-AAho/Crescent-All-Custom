@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass Head API'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_GHEADAPI
  as select from zdt_ghead as a
    inner join   zdt_gitem as b on(
      a.id = b.id
    )
{
  key a.gatepass                               as GateentryNo,
  key b.gateitem                               as GateentryItem,
      b.meins                                  as Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      b.netwt                                  as Netwt,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      b.tarwt                                  as Tarwt,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      b.grswt                                  as Grswt,
      cast( ''  as abap.char( 20 ) )           as Wb1,
      a.ernam                                  as ERNAM,
      cast( ''  as abap.char( 20 ) )           as ERZET,
      cast( a.erdat as abap.char(8) )          as ERDAT,
      b.ebeln                                  as EBELN,
      b.ebelp                                  as EBELP,
      b.vbeln                                  as VBELN,
      b.posnr                                  as POSNR,
      a.plant                                  as Plant,
      a.customercode                           as KUNNR,
      a.vendorcode                             as LIFNR,
      a.vehno                                  as VECHILENO,
      cast( a.gatepassdate as abap.char(8) )   as GateDt,
      a.challannumber                          as ChallanNo,
      cast( a.challandate as abap.char(8) )    as ChallanDate,
      a.transportername                        as TRANSNAME,
      a.vesselname                             as VESSELNAM,
      cast( ''  as abap.char( 20 ) )           as WBTRID,
      a.fromplace                              as FROMPLACE,
      a.toplace                                as TOPLACE,
      a.vendorname                             as PARTYNAME,
      case when a.type = 'PO'
      then 'Inbound'
      when a.type = 'SALES'
      then  'Outbound' end                     as Trans,
      a.multiweight                            as MultiWeight,
      a.noofweight                             as Noofweight,
      cast( a.gateentrydate as abap.char(8) )  as InDate,
      cast( '' as abap.char( 20 ) )            as InTime,
      cast( a.vehicleoutdate as abap.char(8) ) as OutDate,
      cast( '' as abap.char( 20 ) )            as OutTime,
      cast( '' as abap.char( 20 ) )            as SlipNo,
      cast( '' as abap.char( 10 ) )            as LRNo,
      cast( a.lbbldate as abap.char(8) )       as LRDate,
      a.rakeno                                 as RakeNumber,
      a.miningpermissionno                     as MpNo,
      a.miningchallantpno                      as TpNo,
      b.matnr                                  as Matnr,
      b.maktx                                  as MatDesc,
      cast( b.challanqty  as abap.char( 20 ) ) as ChallanQty
}
union select from ZI_HITO_TRANS as a
  inner join      ZI_IITO_TRANS as b on(
    a.Id = b.Id
  )
  left outer join I_Supplier    as c on(
    c.Supplier = a.Lifnr
  )
{
  key a.Itono                              as GateentryNo,
  key b.Itoitem                            as GateentryItem,
      b.Meins                              as Meins,
      b.Ntgew                              as Netwt,
      cast( '0'  as abap.quan( 13, 3 ) )   as Tarwt,
      cast( '0'  as abap.quan( 13, 3 ) )   as Grswt,
      cast( ''  as abap.char( 20 ) )       as Wb1,
      a.Createby                           as ERNAM,
      cast( ''  as abap.char( 20 ) )       as ERZET,
      cast( a.Createdate as abap.char(8) ) as ERDAT,
      cast( '' as abap.char(10) )          as EBELN,
      cast( '' as abap.numc(5) )           as EBELP,
      cast( '' as abap.char(10) )          as VBELN,
      cast( '' as abap.numc(5) )           as POSNR,
      a.Plant                              as Plant,
      cast( '' as abap.char(10) )          as KUNNR,
      a.Lifnr                              as LIFNR,
      a.Vehicleno                          as VECHILENO,
      cast( a.Createdate as abap.char(8) ) as GateDt,
      cast( '' as abap.char(16) )          as ChallanNo,
      cast( '' as abap.char(8) )           as ChallanDate,
      a.Transport                          as TRANSNAME,
      cast( ''  as abap.char( 20 ) )       as VESSELNAM,
      cast( ''  as abap.char( 30 ) )       as WBTRID,
      cast( ''  as abap.char( 20 ) )       as FROMPLACE,
      cast( ''  as abap.char( 20 ) )       as TOPLACE,
      c.SupplierName                       as PARTYNAME,
      'Internal'                           as Trans,
      cast( '' as abap.char( 20 ) )        as MultiWeight,
      cast( '' as abap.char( 20 ) )        as Noofweight,
      cast( a.Createdate as abap.char(8) ) as InDate,
      cast( '' as abap.char( 20 ) )        as InTime,
      cast( a.Createdate as abap.char(8) ) as OutDate,
      cast( '' as abap.char( 20 ) )        as OutTime,
      cast( '' as abap.char( 20 ) )        as SlipNo,
      cast( '' as abap.char( 20 ) )        as LRNo,
      cast( '' as abap.char(8) )           as LRDate,
      ''                                   as RakeNumber,
      ''                                   as MpNo,
      ''                                   as TpNo,
      b.Matnr                              as Matnr,
      b.Maktx                              as MatDesc,
      cast( a.Trgew  as abap.char( 20 ) )  as ChallanQty
}
