@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass Head API'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_C_GHEAD_API
  as select from    zdt_ghead      as a
    inner join      zdt_gitem      as b on(
     b.id = a.id
    )
    left outer join      ZI_GATE_DATE_2 as d on(
      d.Gatepass = a.gatepass
    )
    left outer join ZR_SUPPLIER_F4 as e on a.vendorcode = e.Supplier
    left outer join ZR_CUSTOMER    as f on b.custcode = f.Customer
{
  key a.gatepass                                   as GateentryNo,
  key b.gateitem                                   as GateentryItem,
      b.meins                                      as Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      b.netwt                                      as Netwt,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      b.tarwt                                      as Tarwt,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      b.grswt                                      as Grswt,
      cast( ''  as abap.char( 20 ) )               as Wb1,
      a.ernam                                      as ERNAM,
      cast( ''  as abap.char( 20 ) )               as ERZET,
      d.erdat                                      as ERDAT,
      b.ebeln                                      as EBELN,
      b.ebelp                                      as EBELP,
      b.vbeln                                      as VBELN,
      b.vbelp                                      as POSNR,
      a.plant                                      as Plant,
      b.custcode                                   as KUNNR,
      a.vendorcode                                 as LIFNR,
      a.vehno                                      as VECHILENO,
      cast( d.gatepassdate as abap.char(10) )      as GateDt,
      a.challannumber                              as ChallanNo,
      cast( d.challandate as abap.char(10) )       as ChallanDate,
      cast( a.transportername as abap.char( 40 ) ) as TRANSNAME,
      a.vesselname                                 as VESSELNAM,
      cast( ''  as abap.char( 20 ) )               as WBTRID,
      case when a.type = 'PO' or a.type = 'STO'
      then e.CityName
      when a.type = 'SALES' or a.type = 'SALES RETURN'
      then case when a.plant = '1100'
                then 'Dhenkanal'
                when a.plant = '1600'
                then 'Keonjhar'  end end           as FROMPLACE,
      case when a.type = 'PO' or a.type = 'STO'
           then case when a.plant = '1100'
                then 'Dhenkanal'
                when a.plant = '1600'
                then 'Keonjhar'  end
            when a.type = 'SALES' or a.type = 'SALES RETURN'
            then f.CityName end                    as TOPLACE,
      case when a.type = 'PO' or a.type = 'STO'
      then a.vendorname
      when a.type = 'SALES' or a.type = 'SALES RETURN'
      then  b.custdesc end                         as PARTYNAME,
      case when a.type = 'PO' or a.type = 'STO'
      then 'Inbound'
      when a.type = 'SALES'  or a.type = 'SALES RETURN'
      then  'Outbound' end                         as Trans,
      a.multiweight                                as MultiWeight,
      a.noofweight                                 as Noofweight,
      cast( d.gateentrydate as abap.char(10) )     as InDate,
      cast( '' as abap.char( 20 ) )                as InTime,
      cast( d.vehicleoutdate as abap.char(10) )    as OutDate,
      cast( '' as abap.char( 20 ) )                as OutTime,
      cast( '' as abap.char( 20 ) )                as SlipNo,
      a.lrblno                                     as LRNo,
      cast( d.lbbldate as abap.char(10) )          as LRDate,
      a.rakeno                                     as RakeNumber,
      b.mpno                                       as MpNo,
      b.tpno                                       as TpNo,
      b.matnr                                      as Matnr,
      b.maktx                                      as MatDesc,
      cast( b.challanqty  as abap.char( 20 ) )     as ChallanQty,
      b.weighbentrydate,
      b.weighbentrytime,
      b.weighbexitdate,
      b.weighbexittime
}
where
      a.cancel  is initial
  and a.gateout is initial
  and a.deleted is initial
union select from ZI_HITO_TRANS as a
  inner join      ZI_IITO_TRANS as b on(
    a.Id = b.Id
  )
  left outer join I_Supplier    as c on(
    c.Supplier = a.Lifnr
  )
{
  key a.Itono                                                                                                                                                               as GateentryNo,
  key b.Itoitem                                                                                                                                                             as GateentryItem,
      b.Meins                                                                                                                                                               as Meins,
      b.Ntgew                                                                                                                                                               as Netwt,
      cast( '0'  as abap.quan( 13, 3 ) )                                                                                                                                    as Tarwt,
      cast( '0'  as abap.quan( 13, 3 ) )                                                                                                                                    as Grswt,
      cast( ''  as abap.char( 20 ) )                                                                                                                                        as Wb1,
      a.Createby                                                                                                                                                            as ERNAM,
      cast( ''  as abap.char( 20 ) )                                                                                                                                        as ERZET,
      cast( concat(substring(a.Createdate, 7, 2), concat( '.', concat(substring(a.Createdate, 5, 2) , concat('.' , substring(a.Createdate, 1, 4)  ) ) )) as abap.char(10) ) as ERDAT,
      cast( '' as abap.char(10) )                                                                                                                                           as EBELN,
      cast( '' as abap.numc(5) )                                                                                                                                            as EBELP,
      cast( '' as abap.char(10) )                                                                                                                                           as VBELN,
      cast( '' as abap.numc(6) )                                                                                                                                            as POSNR,
      a.Plant                                                                                                                                                               as Plant,
      cast( '' as abap.char(10) )                                                                                                                                           as KUNNR,
      a.Lifnr                                                                                                                                                               as LIFNR,
      a.Vehicleno                                                                                                                                                           as VECHILENO,
      cast( concat(substring(a.Createdate, 7, 2), concat( '.', concat(substring(a.Createdate, 5, 2) , concat('.' , substring(a.Createdate, 1, 4)  ) ) )) as abap.char(10) ) as GateDt,
      cast( '' as abap.char(16) )                                                                                                                                           as ChallanNo,
      cast( '' as abap.char(8) )                                                                                                                                            as ChallanDate,
      a.Transport                                                                                                                                                           as TRANSNAME,
      cast( ''  as abap.char( 20 ) )                                                                                                                                        as VESSELNAM,
      cast( ''  as abap.char( 30 ) )                                                                                                                                        as WBTRID,
      cast( a.Slgort  as abap.char( 20 ) )                                                                                                                                  as FROMPLACE,
      cast( a.Dlgort  as abap.char( 20 ) )                                                                                                                                  as TOPLACE,
      c.SupplierName                                                                                                                                                        as PARTYNAME,
      'Internal'                                                                                                                                                            as Trans,
      cast( 'N' as abap.char( 20 ) )                                                                                                                                        as MultiWeight,
      cast( '1' as abap.char( 20 ) )                                                                                                                                        as Noofweight,
      cast( concat(substring(a.Createdate, 7, 2), concat( '.', concat(substring(a.Createdate, 5, 2) , concat('.' , substring(a.Createdate, 1, 4)  ) ) )) as abap.char(10) ) as InDate,
      cast( '' as abap.char( 20 ) )                                                                                                                                         as InTime,
      cast( concat(substring(a.Createdate, 7, 2), concat( '.', concat(substring(a.Createdate, 5, 2) , concat('.' , substring(a.Createdate, 1, 4)  ) ) )) as abap.char(10) ) as OutDate,
      cast( '' as abap.char( 20 ) )                                                                                                                                         as OutTime,
      cast( '' as abap.char( 20 ) )                                                                                                                                         as SlipNo,
      cast( '' as abap.char( 20 ) )                                                                                                                                         as LRNo,
      cast( '' as abap.char(8) )                                                                                                                                            as LRDate,
      ''                                                                                                                                                                    as RakeNumber,
      ''                                                                                                                                                                    as MpNo,
      ''                                                                                                                                                                    as TpNo,
      b.Matnr                                                                                                                                                               as Matnr,
      b.Maktx                                                                                                                                                               as MatDesc,
      cast( a.Trgew  as abap.char( 20 ) )                                                                                                                                   as ChallanQty,
      cast( '' as abap.char(20) )                                                                                                                                           as weighbentrydate,
      cast( '' as abap.char(20) )                                                                                                                                           as weighbentrytime,
      cast( '' as abap.char(20) )                                                                                                                                           as weighbexitdate,
      cast( '' as abap.char(20) )                                                                                                                                           as weighbexittime
}
where
  b.Ntgew is initial
