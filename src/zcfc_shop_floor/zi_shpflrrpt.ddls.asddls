@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor Prod-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SHPFLRRPT
  as select distinct from ZI_CONF_HDR         as a
    inner join            ZI_CONF_ITM         as b on  a.Shpflrno = b.Shpflrno
                                                   and a.Id       = b.Id
    left outer join       I_UnitOfMeasure     as c on b.Meins = c.UnitOfMeasure
    left outer join       ZI_CONFPOST_ORD     as d on  a.Shpflrno = d.Shpflrno
                                                   and a.Id       = d.Refid
                                                   and b.Matnr    = d.Matnr
    left outer join       I_UnitOfMeasure     as e on d.Meins = e.UnitOfMeasure
    left outer join       I_BusinessUserBasic as f on f.UserID = a.Creby

    left outer join       zdt_pp_matinffld    as g on b.Matnr = g.product
{
  key    a.Shpflrno,
  key    b.Item                                           as itemkey,
  key    d.Ord                                            as orderkey,
         a.Shpflrdt,
         f.PersonFullName                                 as CreatedBy,
         a.Creon                                          as CreatedOn,
         a.Plant,
         a.Dept,
         a.Deptname,
         a.Opr,
         a.Oprname,
         a.Cont,
         a.Contname,
         b.Matnr,
         b.Maktx,
         c.UnitOfMeasure_E,
         b.Pattern,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Totmou,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Goodcast,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Totcast,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty1,
         b.Rejrea1,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty2,
         b.Rejrea2,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty3,
         b.Rejrea3,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty4,
         b.Rejrea4,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty5,
         b.Rejrea5,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty6,
         b.Rejrea6,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty7,
         b.Rejrea7,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty8,
         b.Rejrea8,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Rejqty9,
         b.Rejrea9,
         b.Meins,
         @Semantics.quantity.unitOfMeasure: 'Wtunit'
         b.Stdwt,
         @Semantics.quantity.unitOfMeasure: 'Wtunit'
         b.Actwt,
         b.Wtunit,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Totqty,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Allocqty,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Balqty,
         g.machloss                                       as Machloss,
         b.Qtyperbox,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         b.Totmouqty,
         b.So,
         b.Soitm,
         b.Sofg,
         b.Metalcrqty,
         d.Prodord,
         cast( d.Pendprqty as abap.dec(13,3) )            as Pendprqty,
         e.UnitOfMeasure_E                                as UOM,
         (case when d.Rej = 'X' then 'Yes' else 'No' end) as Rejected,
         d.Serial,
         d.Heatno
}

//where
//  d.Rej = ''
