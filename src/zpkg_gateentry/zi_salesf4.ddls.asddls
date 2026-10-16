@AbapCatalog.sqlViewName: 'ZSALES4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales f4'
define view zi_salesf4
  as select distinct from zi_deliverydocumentitem as a
  //    inner join            zi_sales1              as b on b.DeliveryDocument = a.DeliveryDocument
    left outer join       I_DeliveryDocument      as c on c.DeliveryDocument = a.DeliveryDocument
    left outer join       I_Customer              as d on d.Customer = c.SoldToParty
    inner join            zi_transporterdetails   as e on e.Delivery = a.DeliveryDocument
    left outer join       zdt_gitem               as f on  f.vbeln = a.DeliveryDocument
                                                       and f.vbelp = a.DeliveryDocumentItem
    left outer join       zdt_ghead               as g on g.id = f.id

{
  key           a.DeliveryDocument,
  key           a.DeliveryDocumentItem,
  key           e.forwarder                         as Transportercode,
  key           e.forwardernam                      as Transportername,
                a.ItemNetWeight,
                //    'Sales'                             as Type,
                cast( c.CreationDate as abap.dats ) as creationdate,
                //      b.YY1_VehicleNumber_DLH,

                a.Product,
                a.DeliveryDocumentItemText,
                a.ActualDeliveryQuantity,
                a.DeliveryQuantityUnit,
                a.ReferenceSDDocument,
                a.ReferenceSDDocumentItem,
                c.SoldToParty,
                d.CustomerName,
                e.Contno                            as ContainerNumber,
                f.vbeln,
                f.vbelp,
                a.Plant,
                g.deleted,
                cast( 'SALES' as abap.char( 20 ))   as Type

                //      c.YY1_Transportername_DLH

}
where
          OverallGoodsMovementStatus <> 'C'
  and(
          c.TotalCreditCheckStatus   =  ''
    or    c.TotalCreditCheckStatus   =  'A'
    or    c.TotalCreditCheckStatus   =  'D'
  )
  and(
          f.vbeln                    is null
    or(
          f.vbeln                    is not null
      and g.deleted                  =  'X'
    )
  )
  and     c.DeliveryDocumentType     =  'LF'
union select distinct from zi_deliverydocumentitem as a
//    inner join            zi_sales1              as b on b.DeliveryDocument = a.DeliveryDocument
  left outer join          I_DeliveryDocument      as c on c.DeliveryDocument = a.DeliveryDocument
  left outer join          I_Customer              as d on d.Customer = c.SoldToParty
  inner join               zi_transporterdetails   as e on e.Delivery = a.DeliveryDocument
  left outer join          zdt_gitem               as f on  f.vbeln = a.DeliveryDocument
                                                        and f.vbelp = a.DeliveryDocumentItem
  left outer join          zdt_ghead               as g on g.id = f.id

{
  key           a.DeliveryDocument,
  key           a.DeliveryDocumentItem,
  key           e.forwarder                               as Transportercode,
  key           e.forwardernam                            as Transportername,
                a.ItemNetWeight,
                //   'Production'                        as Type,
                cast( c.CreationDate as abap.dats )       as creationdate,
                //      b.YY1_VehicleNumber_DLH,

                a.Product,
                a.DeliveryDocumentItemText,
                a.ActualDeliveryQuantity,
                a.DeliveryQuantityUnit,
                a.ReferenceSDDocument,
                a.ReferenceSDDocumentItem,
                c.SoldToParty,
                d.CustomerName,
                '  '                                      as ContainerNumber,
                f.vbeln,
                f.vbelp,
                a.Plant,
                g.deleted,
                cast( 'SALES RETURN' as abap.char( 20 ) ) as Type



                //      c.YY1_Transportername_DLH

}
where
          OverallGoodsMovementStatus <> 'C'
  and(
          c.TotalCreditCheckStatus   =  ''
    or    c.TotalCreditCheckStatus   =  'A'
    or    c.TotalCreditCheckStatus   =  'D'
  )
  and(
          f.vbeln                    is null
    or(
          f.vbeln                    is not null
      and g.deleted                  =  'X'
    )
  )
  and(
          c.DeliveryDocumentType     =  'LR2'
  )
union select distinct from zi_deliverydocumentitem as a
//    inner join            zi_sales1              as b on b.DeliveryDocument = a.DeliveryDocument
  left outer join          I_DeliveryDocument      as c on c.DeliveryDocument = a.DeliveryDocument
  left outer join          I_Customer              as d on d.Customer = c.SoldToParty
//  inner join            zi_transporterdetails   as e on e.Delivery = a.DeliveryDocument
  left outer join          zdt_gitem               as f on  f.vbeln = a.DeliveryDocument
                                                        and f.vbelp = a.DeliveryDocumentItem
  left outer join          zdt_ghead               as g on g.id = f.id

{
  key           a.DeliveryDocument,
  key           a.DeliveryDocumentItem,
                '  '                                     as Transportercode,
                '  '                                     as Transportername,
                //   'Production'                        as Type,
                a.ItemNetWeight,
                cast( c.CreationDate as abap.dats )      as creationdate,

                //      b.YY1_VehicleNumber_DLH,

                a.Product,
                a.DeliveryDocumentItemText,
                a.ActualDeliveryQuantity,
                a.DeliveryQuantityUnit,
                a.ReferenceSDDocument,
                a.ReferenceSDDocumentItem,
                c.SoldToParty,
                d.CustomerName,
                '  '                                     as ContainerNumber,
                f.vbeln,
                f.vbelp,
                a.Plant,
                g.deleted,
                cast( 'STO OUTBOUND' as abap.char( 20 )) as Type


                //      c.YY1_Transportername_DLH

}
where
       OverallGoodsMovementStatus <> 'C'
  and(
       f.vbeln                    is null
    or g.deleted                  =  'X'
  )
  and(
       c.DeliveryDocumentType     =  'JNL'
  )
