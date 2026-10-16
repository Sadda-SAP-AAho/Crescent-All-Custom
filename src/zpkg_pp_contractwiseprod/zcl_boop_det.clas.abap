CLASS zcl_boop_det DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_func_billofop.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BOOP_DET IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING Z_I_BILLOFOPRN.


   lt_item = select mandt , cast( ActivityType as char(6)) as ActivityType,
                            cast( CostCenter as char(10)) as CostCenter,
                            Currency,
                            cast( CostRateFixedAmount as dec( 23,2 )) as CostRateFixedAmount,
                            validitystartdate ValidityStartDate,
                            validityenddate   as ValidityEndDate

    from Z_I_BILLOFOPRN;



     RETURN  select *
       from :lt_item;



  ENDMETHOD.
ENDCLASS.
