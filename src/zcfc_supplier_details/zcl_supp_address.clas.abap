CLASS zcl_supp_address DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_supplier_address.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SUPP_ADDRESS IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                             FOR HDB
                             LANGUAGE SQLSCRIPT
                             OPTIONS READ-ONLY
                             USING z_i_supplier_address.

    lt_item_3 = select * from z_i_supplier_address;

        lt_item = SELECT a.mandt as mandt,
                         a.BusinessPartner as suppcode,
                         StreetName,
                         CityName,
                         Region,
                         Country,
                         PostalCode
                  from :lt_item_3 as a
                  order by suppcode asc;

        return  select *
                from :lt_item
                order by suppcode asc;

  ENDMETHOD.
ENDCLASS.
