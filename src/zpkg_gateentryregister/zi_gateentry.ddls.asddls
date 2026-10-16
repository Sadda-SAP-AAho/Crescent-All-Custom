//@AbapCatalog.sqlViewName: 'ZGATEREG'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gateentry Register'
define root view entity ZI_GATEENTRY
  as select distinct from zdt_ghead as a
    left outer join       zdt_gitem as b on a.id = b.id
{
  key    a.id                                          as Id,
  key    b.item                                        as Item,
         a.challannumber                               as Challannumber,
         a.challandate                                 as Challandate,
         case when b.item is null then 'Item not added'
         else a.status
         end                                           as status,
         case  when b.item is null then 1
         when a.status = 'Created' then 2
         when a.status = 'Vehicle In' then 2
         when a.status = 'Canceled' then 1
         when a.status = 'Deleted' then 1
         when a.status = 'Exit Confirmed' then 3
         else 3 end                                    as Criticality,
         cast( case a.status when 'Created' then 25
                             when 'Vehicle In' then 50
                             when 'Canceled' then 100
                             when 'Deleted' then 100
                             when 'Exit Confirmed' then 100
                             else 0 end as abap.int4 ) as Progress,
         a.rrno                                        as Rrno,
         a.rrdate                                      as Rrdate,
         a.lrblno                                      as Lrblno,
         a.lbbldate                                    as Lbbldate,
         a.billofentryno                               as Billofentryno,
         a.billofentrydate                             as Billofentrydate,
         a.miningpermissionno                          as Miningpermissionno,
         a.waybillno                                   as Waybillno,
         //  a.miningchallantpno as Miningchallantpno,
         b.mpno                                        as MiningchallanMpno,
         b.tpno                                        as Miningchallantpno,
         a.plantgateno                                 as Plantgateno,
         a.plantweighbridgeno                          as Plantweighbridgeno,
         a.shipmenttype                                as Shipmenttype,
         a.vehno                                       as Vehno,
         a.containernumber                             as ContainerNumber,
         a.vesselname                                  as Vesselname,
         a.rakeno                                      as Rakeno,
         a.raketripno                                  as Raketripno,
         a.ernam                                       as Ernam,
         a.erdat                                       as Erdat,
         a.erzet                                       as Erzet,
         a.gateentrydate                               as Gateentrydate,
         a.gateentrytime                               as Gateentrytime,
         a.vendorcode                                  as Vendorcode,
         a.vendorname                                  as Vendorname,
         a.customercode                                as Customercode,
         a.customername                                as Customername,
         a.drivername                                  as Drivername,
         a.drivercellno                                as Drivercellno,
         a.dlno                                        as Dlno,
         a.vehiclecheck                                as Vehiclecheck,
         a.testcertificate                             as Testcertificate,
         a.taxinvoice                                  as Taxinvoice,
         a.transportercode                             as Transportercode,
         a.transportername                             as Transportername,
         a.invoice                                     as Invoice,
         a.invoicedate                                 as Invoicedate,
         a.remarks                                     as Remarks,
         a.gatepass                                    as Gatepass,
         a.gatepassdate                                as Gatepassdate,
         a.purchasingdocumentnumber                    as Purchasingdocumentnumber,
         a.vehicleoutdate                              as Vehicleoutdate,
         a.vehicleouttime                              as Vehicleouttime,
         a.unloaddate                                  as Unloaddate,
         a.unloadtime                                  as Unloadtime,
         a.gateout                                     as Gateout,
         a.deleted                                     as Deleted,
         a.cancel                                      as Cancel,
         a.miscnumber                                  as Miscnumber,
         a.miscdate                                    as Miscdate,
         a.currentyear                                 as Currentyear,
         a.currentnumber                               as Currentnumber,
         a.bukrs                                       as Bukrs,
         a.plant                                       as Plant,
         a.type                                        as Type,
         a.meins                                       as Meins,
         a.netwt                                       as Netwt,
         a.tarwt                                       as Tarwt,
         a.grswt                                       as Grswt,
         a.deleteuser                                  as Deleteuser,
         a.deletedate                                  as Deletedate,
         // a.status                                      as Status,
         //   a.criticality                                 as Criticality,
         a.printr                                      as Printr,
         b.ebeln                                       as Ebeln,
         b.ebelp                                       as Ebelp,
         b.vbeln                                       as Vbeln,
         b.vbelp                                       as Vbelp,
         b.matnr                                       as Matnr,
         b.maktx                                       as Maktx,
         b.posnr                                       as Posnr,
         b.vbelnvf                                     as VbelnVf,
         b.posnrvf                                     as PosnrVf,
         b.mblnr                                       as Mblnr,
         b.mjahr                                       as Mjahr,
         b.zeile                                       as Zeile,
         b.challanqty                                  as Challanqty,
         b.orderqty                                    as Orderqty,
         b.totalqty                                    as Totalqty,
         b.balanceqty                                  as Balanceqty,
         b.deliverqty                                  as Deliverqty
}
