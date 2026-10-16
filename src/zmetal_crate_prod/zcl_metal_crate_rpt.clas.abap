CLASS zcl_metal_crate_rpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ZTBL_FCTN_METALCRATE1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_METAL_CRATE_RPT IMPLEMENTATION.


METHOD get_data
BY DATABASE FUNCTION
                       FOR HDB
                       LANGUAGE SQLSCRIPT
                       OPTIONS READ-ONLY
                       USING zcds_metalcrtprd I_BILLOFMATERIALITEMTP_2.

  lt_item = SELECT * FROM zcds_metalcrtprd;
  lt_item_1 = SELECT CAST( a.mandt_1 as Char( 3 ) ) as mandt,a.itemcode ,b.billofmaterialcategory, b.billofmaterial,b.billofmaterialvariant ,b.billofmaterialversion,
              b.billofmaterialitemnodenumber ,b.headerchangedocument ,b.material ,b.plant ,b.BillOfMaterialItemQuantity
              from :lt_item as a
              INNER JOIN I_BILLOFMATERIALITEMTP_2 as b ON a.material = b.material and a.plant = b.plant;

   RETURN  select *
       from :lt_item_1
     ORDER BY billofmaterial ASC;

ENDMETHOD.
ENDCLASS.
