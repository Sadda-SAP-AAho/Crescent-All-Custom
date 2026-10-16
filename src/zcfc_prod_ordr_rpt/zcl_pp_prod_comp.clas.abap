CLASS zcl_pp_prod_comp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data  FOR TABLE FUNCTION ztbl_fctn_prod_component.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_PROD_COMP IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING  Z_I_PROD_COMP.

    lt_item_3 = select * from Z_I_PROD_COMP;

        lt_item = SELECT a.mandt as mandt, a.productionorder, a.reservation, a.reservationitem,
                         a.billofmaterialinternalid, a.billofmaterialitemnumber, a.material, a.plant, a.StorageLocation,
                         a.materialgroup, a.reservationisfinallyissued, a.requiredquantity, a.withdrawnquantity,
                         a.WithdrawnQuantityAmount
                  from :lt_item_3 as a
                  group by a.mandt, a.productionorder, a.reservation, a.reservationitem,
                         a.billofmaterialinternalid, a.billofmaterialitemnumber, a.material, a.plant, a.StorageLocation,
                         a.materialgroup, a.reservationisfinallyissued, a.requiredquantity, a.withdrawnquantity,
                         a.WithdrawnQuantityAmount;

        return  select *
                from :lt_item
                order by billofmaterialinternalid asc, productionorder asc,reservation asc,
                         reservationitem asc, billofmaterialitemnumber asc, material, plant asc, StorageLocation asc;

  ENDMETHOD.
ENDCLASS.
