@EndUserText.label: 'Sales Retrun'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@AbapCatalog.sqlViewName: 'ZISALESRET'
define view ZI_SALES_RETURN
  as select distinct from zi_deliverydocumentitem as a
  //    inner join            zi_sales1              as b on b.DeliveryDocument = a.DeliveryDocument
    left outer join       I_DeliveryDocument      as c on c.DeliveryDocument = a.DeliveryDocument
    left outer join       I_Customer              as d on d.Customer = c.SoldToParty
    inner join            zi_transporterdetails   as e on e.Delivery = a.DeliveryDocument
    left outer join       zdt_gitem               as f on  f.vbeln = a.DeliveryDocument
                                                       and f.vbelp = a.DeliveryDocumentItem
    left outer join       zdt_ghead               as g on g.id = f.id
{
  key              a.DeliveryDocument,
  key              a.DeliveryDocumentItem,
  key              cast( e.forwarder as abap.char( 10 ) )    as Transportercode,
  key              cast( e.forwardernam as abap.char( 60 ) ) as Transportername,
  key              a.ItemNetWeight,
                   //      '  '           as Type,
  key              c.CreationDate,
                   //      b.YY1_VehicleNumber_DLH,
  key              a.Product,
  key              a.DeliveryDocumentItemText,
  key              a.ActualDeliveryQuantity,
  key              a.DeliveryQuantityUnit,
  key              a.ReferenceSDDocument,
  key              a.ReferenceSDDocumentItem,
  key              c.SoldToParty,
  key              d.CustomerName,
  key              e.Contno                                  as ContainerNumber,
  key              f.vbeln,
  key              f.vbelp,
  key              a.Plant,
  key              g.deleted,
                   cast( 'SALES' as abap.char( 20 ))         as Type
                   //      c.YY1_Transportername_DLH

}
where
       OverallGoodsMovementStatus <> 'C'
  and  DeliveryDocumentType       =  'LF'
  and(
       c.TotalCreditCheckStatus   =  ''
    or c.TotalCreditCheckStatus   =  'A'
    or c.TotalCreditCheckStatus   =  'D'
  )
  and(
       f.vbeln                    is null
    or g.deleted                  =  'X'
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
                cast( '' as abap.char( 10 ))              as Transportercode,
                cast( '' as abap.char( 60 ))              as Transportername,
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
    or c.TotalCreditCheckStatus   =  'A'
    or c.TotalCreditCheckStatus   =  'D'
  )
  and(
       f.vbeln                    is null
    or g.deleted                  =  'X'
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
                cast( '' as abap.char( 10 ))              as Transportercode,
                cast( '' as abap.char( 60 ))              as Transportername,
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
                cast( 'STO OUTBOUND' as abap.char( 20 ) ) as Type


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
