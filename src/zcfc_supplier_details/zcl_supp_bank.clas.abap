CLASS zcl_supp_bank DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_supplier_bank.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SUPP_BANK IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                               FOR HDB
                               LANGUAGE SQLSCRIPT
                               OPTIONS READ-ONLY
                               USING z_i_supplier_bank.

    lt_item_3 = select * from z_i_supplier_bank;

        lt_item = SELECT a.mandt as mandt,
                         a.businesspartner,
                         a.banknumber,
                         a.bankaccount,
                         a.bankaccountholdername
                  from :lt_item_3 as a
                  order by a.businesspartner asc;


        return  select *
                from :lt_item
                order by businesspartner asc;

  endmethod.
ENDCLASS.
