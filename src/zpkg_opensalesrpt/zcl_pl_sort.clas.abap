CLASS zcl_pl_sort DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort_data FOR TABLE FUNCTION ztbl_func_packlist.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PL_SORT IMPLEMENTATION.


  METHOD sort_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING ZCDS_PACKLIST_NO.


   lt_item1 = select ReferenceSDDocument ,ReferenceSDDocumentItem,max(  zdatetime  ) as zdatetime
   from ZCDS_PACKLIST_NO
   group by ReferenceSDDocument ,ReferenceSDDocumentItem;

   lt_item  = select a.mandt,a.ReferenceSDDocument ,a.ReferenceSDDocumentItem,
                     a.Createdon,a.Changedat,a.zdatetime,a.packinglist
   from ZCDS_PACKLIST_NO as a
   inner join :lt_item1 as b on a.ReferenceSDDocument = b.ReferenceSDDocument
                             and a.ReferenceSDDocumentItem = b.ReferenceSDDocumentItem
                             and a.zdatetime = b.zdatetime ;


      RETURN  select *
       from :lt_item;
*     ORDER BY Createdon DESC, Changedat DESC;


  ENDMETHOD.
ENDCLASS.
