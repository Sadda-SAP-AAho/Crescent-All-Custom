@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Conf Post Order'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_CONFPOST_ORD
  as select from zdt_confpost_ord
  association to parent ZI_CONFPOST_HDR as _Head on $projection.Id = _Head.Id
{
  key zdt_confpost_ord.id                   as Id,
  key zdt_confpost_ord.item                 as Item,
  key zdt_confpost_ord.ord                  as Ord,
      zdt_confpost_ord.refid                as Refid,
      zdt_confpost_ord.refitem              as RefItem,
      zdt_confpost_ord.reford               as Reford,
      zdt_confpost_ord.shpflrno             as Shpflrno,
      zdt_confpost_ord.matnr                as Matnr,
      zdt_confpost_ord.plant                as Plant,
      zdt_confpost_ord.prodord              as Prodord,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_confpost_ord.pendprqty            as Pendprqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_confpost_ord.postqty              as Postqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_confpost_ord.balqty               as Balqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_confpost_ord.alpostqty            as Alpostqty,
      zdt_confpost_ord.meins                as Meins,
      zdt_confpost_ord.serial               as Serial,
      zdt_confpost_ord.heatno               as Heatno,
      zdt_confpost_ord.rej                  as Rej,
      zdt_confpost_ord.ordersta             as Ordersta,
      zdt_confpost_ord.docsta               as Docsta,
      zdt_confpost_ord.status               as Status,
      zdt_confpost_ord.uniqueid             as Uniqueid,
      case when zdt_confpost_ord.docsta = ''  then cast( 0 as abap.int4 )
           when zdt_confpost_ord.docsta = 'P' then cast( 100 as abap.int4 )
           when zdt_confpost_ord.docsta = 'R' then cast( 75 as abap.int4 )
           when zdt_confpost_ord.docsta = 'I' then cast( 25 as abap.int4 )
           when zdt_confpost_ord.docsta = 'S' then cast( 50 as abap.int4 )
           else cast( 0 as abap.int4 )  end as Progress,
      case when zdt_confpost_ord.docsta = ''  then cast( 1 as abap.int1 )
           when zdt_confpost_ord.docsta = 'S' then cast( 2 as abap.int1 )
           when zdt_confpost_ord.docsta = 'R' then cast( 2 as abap.int1 )
           when zdt_confpost_ord.docsta = 'I' then cast( 2 as abap.int1 )
           when zdt_confpost_ord.docsta = 'P' then cast( 3 as abap.int1 )
           else cast( 1 as abap.int1 )  end as Criticality,
      cast( 100 as abap.int4 )              as Total,
      _Head
}
