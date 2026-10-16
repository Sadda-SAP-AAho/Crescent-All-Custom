@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Detention Report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_SALESDETENTION_V1

  as select distinct from I_BillingDocument  as a

    inner join            ZI_BILLINGDOCITEM  as b on b.BillingDocument = a.BillingDocument

    inner join            I_DeliveryDocument as c on c.DeliveryDocument = b.ReferenceSDDocument


    inner join            zdt_packlist_hdr   as d on d.delivery = c.DeliveryDocument

    inner join            ZI_DELDASH_HDR     as e on e.Delivery = c.DeliveryDocument

    inner join            I_DeliveryDocument as f on f.DeliveryDocument = b.ReferenceSDDocument

    inner join            I_Plant            as g on g.Plant = b.Plant

    left outer join       zc_gateentry       as h on h.Vbeln = c.DeliveryDocument

    left outer join       ZI_MATFLD          as i on i.Product = b.Product

    left outer join       I_CalendarDate     as j on j.CalendarDate = e.Conliftdt

    left outer join       zdt_salesdetentn   as k on k.deliverydocument = c.DeliveryDocument

{
  key a.BillingDocument                             as ARInvNo,
      a.CreationDate,
      a.CreationTime,
      a.PayerParty                                  as CustomerCode,
      c.DeliveryDocument,
      d.packinglist                                 as PackingList,
      e.Salesnoteref                                as ContainerNickName,
      case when f.OverallGoodsMovementStatus = 'C'
           then f.ActualGoodsMovementDate  end      as DeliveryDate,
      e.Contno                                      as ContainerNo,
      e.Conpckvaldt                                 as ContainerPickupValidityDate,
      e.Conliftdt                                   as ContainerActualPickupDate,
      j.WeekDay                                     as ContainerActualPickupWeekDay,
      e.Confacindt                                  as ContainerFactoryInDate,
      h.Vehicleoutdate                              as ContainerFactoryOutDate,
      e.Carordappdt                                 as CartingOrderAppDate,
      e.Cartordrecdt                                as CartingOrderRecDate,
      e.Condockindt                                 as ContainerDockInDate,
      e.Concutoffdt                                 as ContainerCutoffDate,
      dats_add_days( e.Concutoffdt, -4, 'INITIAL' ) as GateOpenDate,
      h.Transportername                             as TransporterName,
      e.forwardernam                                as Forwarder,
      e.Shipline                                    as ShippingLine,
      a.TransactionCurrency                         as TrxnCurrency,
      a.AccountingExchangeRate                      as ExchangeRate,
      e.Consizen                                    as ContainerSize,
      g.PlantName                                   as PlantName,
      g.Plant                                       as Plant,
      i.moc                                         as MOC,
      k.truckholdingdays                            as Truckholdingdays,
      k.truckdetentionamount                        as Truckdetentionamount,
      k.factorydetentiondays                        as Factorydetentiondays,
      k.factorydetentionamount                      as Factorydetentionamount,
      k.docdetentiondays                            as Docdetentiondays,
      k.docdetentionamount                          as Docdetentionamount,
      k.updated

}

where
      a.BillingDocumentIsCancelled = ''
  and a.BillingDocumentType        = 'F2'
  and e.Canind                     = ''
