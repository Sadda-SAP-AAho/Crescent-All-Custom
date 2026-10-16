@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Conf Post Item'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_CONFPOST_ITM
  as select from zdt_confpost_itm
  association to parent ZI_CONFPOST_HDR as _Head on $projection.Id = _Head.Id
{
  key id         as Id,
  key item       as Item,
      refid      as Refid,
      refitem    as Refitem,
      shpflrno   as Shpflrno,
      matnr      as Matnr,
      maktx      as Maktx,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      totmou     as Totmou,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      totmouqty  as Totmouqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      goodcast   as Goodcast,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty1    as Rejqty1,
      rejrea1    as Rejrea1,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty2    as Rejqty2,
      rejrea2    as Rejrea2,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty3    as Rejqty3,
      rejrea3    as Rejrea3,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty4    as Rejqty4,
      rejrea4    as Rejrea4,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty5    as Rejqty5,
      rejrea5    as Rejrea5,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty6    as Rejqty6,
      rejrea6    as Rejrea6,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty7    as Rejqty7,
      rejrea7    as Rejrea7,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty8    as Rejqty8,
      rejrea8    as Rejrea8,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      rejqty9    as Rejqty9,
      rejrea9    as Rejrea9,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      totcast    as Totcast,
      meins      as Meins,
      noofhead   as Noofhead,
      prodord    as Prodord,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      pendprqty  as Pendprqty,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      stdwt      as Stdwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      actwt      as Actwt,
      wtunit     as Wtunit,
      @Semantics.quantity.unitOfMeasure : 'meins'
      totqty     as Totqty,
      @Semantics.quantity.unitOfMeasure : 'meins'
      allocqty   as Allocqty,
      @Semantics.quantity.unitOfMeasure : 'meins'
      balqty     as Balqty,
      ordersta   as Ordersta,
      docsta     as Docsta,
      pattern    as Pattern,
      machloss   as Machloss,
      qtyperbox  as Qtyperbox,
      so         as So,
      soitm      as Soitm,
      sofg       as Sofg,
      metalcrqty as Metalcrqty,
      _Head // Make association public
}
