@EndUserText.label: 'Interface view gatepass header'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L


define root view entity zi_ghead
  as select from zdt_ghead
  composition [0..*] of ZI_GITEM as _Item
{
  key zdt_ghead.id                                  as Id,
      zdt_ghead.challannumber                       as Challannumber,
      zdt_ghead.challandate                         as Challandate,
      zdt_ghead.rrno                                as Rrno,
      zdt_ghead.rrdate                              as Rrdate,
      zdt_ghead.lrblno                              as Lrblno,
      zdt_ghead.lbbldate                            as Lbbldate,
      zdt_ghead.billofentryno                       as Billofentryno,
      zdt_ghead.billofentrydate                     as Billofentrydate,
      zdt_ghead.miningpermissionno                  as Miningpermissionno,
      zdt_ghead.waybillno                           as Waybillno,
      zdt_ghead.miningchallantpno                   as Miningchallantpno,
      zdt_ghead.plantgateno                         as Plantgateno,
      zdt_ghead.plantweighbridgeno                  as Plantweighbridgeno,
      zdt_ghead.shipmenttype                        as Shipmenttype,
      zdt_ghead.vehno                               as Vehno,
      zdt_ghead.containernumber                     as ContainerNumber,
      zdt_ghead.vesselname                          as Vesselname,
      zdt_ghead.rakeno                              as Rakeno,
      zdt_ghead.raketripno                          as Raketripno,
      zdt_ghead.ernam                               as Ernam,
      zdt_ghead.erdat                               as Erdat,
      zdt_ghead.erzet                               as Erzet,
      zdt_ghead.gateentrydate                       as Gateentrydate,
      zdt_ghead.gateentrytime                       as Gateentrytime,
      zdt_ghead.vendorcode                          as Vendorcode,
      zdt_ghead.vendorname                          as Vendorname,
      zdt_ghead.customercode                        as Customercode,
      zdt_ghead.customername                        as Customername,
      zdt_ghead.drivername                          as Drivername,
      zdt_ghead.drivercellno                        as Drivercellno,
      zdt_ghead.dlno                                as Dlno,
      zdt_ghead.vehiclecheck                        as Vehiclecheck,
      zdt_ghead.testcertificate                     as Testcertificate,
      zdt_ghead.taxinvoice                          as Taxinvoice,
      zdt_ghead.transportercode                     as Transportercode,
      zdt_ghead.transportername                     as Transportername,
      zdt_ghead.invoice                             as Invoice,
      zdt_ghead.invoicedate                         as Invoicedate,
      zdt_ghead.remarks                             as Remarks,
      zdt_ghead.gatepass                            as Gatepass,
      zdt_ghead.gatepassdate                        as Gatepassdate,
      zdt_ghead.purchasingdocumentnumber            as Purchasingdocumentnumber,
      zdt_ghead.vehicleoutdate                      as Vehicleoutdate,
      zdt_ghead.vehicleouttime                      as Vehicleouttime,
      zdt_ghead.unloaddate                          as Unloaddate,
      zdt_ghead.unloadtime                          as Unloadtime,
      zdt_ghead.gateout                             as Gateout,
      zdt_ghead.deleted                             as Deleted,
      zdt_ghead.cancel                              as Cancel,
      zdt_ghead.tprint                              as TPrint,
      zdt_ghead.miscnumber                          as Miscnumber,
      zdt_ghead.miscdate                            as Miscdate,
      zdt_ghead.currentyear                         as Currentyear,
      zdt_ghead.currentnumber                       as Currentnumber,
      zdt_ghead.bukrs                               as Bukrs,
      zdt_ghead.plant                               as Plant,
      zdt_ghead.type                                as Type,
      zdt_ghead.meins                               as Meins,
      zdt_ghead.netwt                               as Netwt,
      zdt_ghead.tarwt                               as Tarwt,
      zdt_ghead.grswt                               as Grswt,
      zdt_ghead.vendor_netwt                        as Vendor_Netwt,
      zdt_ghead.vendor_tarwt                        as Vendor_Tarwt,
      zdt_ghead.vendor_grswt                        as Vendor_Grswt,
      zdt_ghead.deleteuser                          as Deleteuser,
      zdt_ghead.deletedate                          as Deletedate,
      zdt_ghead.status                              as Status,
      case  when status = 'Created' then 1
            when status = 'Vehicle In' then 2
            when status = 'Canceled' then 3
            when status = 'Deleted' then 3
            when status = 'Exit Confirmed' then 2
            else 3 end                              as Criticality,
      cast( case status when 'Created' then 25
                          when 'Vehicle In' then 50
                          when 'Canceled' then 100
                          when 'Deleted' then 100
                          when 'Exit Confirmed' then 100
                          else 0 end as abap.int4 ) as Progress,
      cast( 100 as abap.int4 )                      as Total,
      zdt_ghead.printr                              as Printr,
      zdt_ghead.wlfpl                               as Wlfpl,
      zdt_ghead.item                                as Item,
      zdt_ghead.fromplace                           as Fromplace,
      zdt_ghead.toplace                             as Toplace,
      zdt_ghead.multiweight                         as Multiweight,
      zdt_ghead.noofweight                          as Noofweight,
      zdt_ghead.mpno                                as Mpno,
      zdt_ghead.tpno                                as Tpno,
      zdt_ghead.currency     as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_ghead.amountt                             as Amountt,
      rgpgatepass,
      rgpdate,
      deliverynumber,
      sendername,
      _Item
}
