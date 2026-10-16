@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Tax Invoice Item Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_REPPRNT_ITM
//  as select from    ZI_CONTRACT_HDR                      as i
//  inner join        ZI_CONTRACT_ITM                      as j
  as select from    zdt_contract_hdr                      as i
  inner join        zdt_contract_itm                      as j
                                                         on j.cont = i.cont 
                                                         and j.plant = i.plant
                                                         and j.opr = i.opr
                                                         and j.dept = i.dept
  {
        key j.opr,
        key j.plant,
        key j.dept,
        key j.cont,
        j.matnr,
        j.itemname as ProductDescription,
        j.weightunit,
        @Semantics.quantity.unitOfMeasure: 'WeightUnit'
        j.netweight,
        j.materialbaseunit,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.day1qty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.day2qty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.day3qty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.day4qty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.day5qty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.day6qty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.day7qty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.totalperdayqty,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        j.qtyinkg,
        j.activity1,
        j.activity2,
        j.activity3,
        j.activity4,
        j.activity1amt,
        j.activity2amt,
        j.activity3amt,
        j.activity4amt,
        j.totalamt
        
  }
group by 
//        j.shpflrdt,
         j.opr,
         j.plant,
         j.dept,
         j.cont,
         j.matnr,
         j.itemname,
         j.weightunit,
         j.netweight,
         j.materialbaseunit,
         j.day1qty,
         j.day2qty,
         j.day3qty,
         j.day4qty,
         j.day5qty,
         j.day6qty,
         j.day7qty,
         j.totalperdayqty,
         j.qtyinkg,
         j.activity1,
         j.activity2,
         j.activity3,
         j.activity4,
         j.activity1amt,
         j.activity2amt,
         j.activity3amt,
         j.activity4amt,
         j.totalamt
  
