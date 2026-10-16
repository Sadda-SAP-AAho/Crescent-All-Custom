CLASS zcl_serinv_item_print DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fucn_iteminv.
ENDCLASS.



CLASS ZCL_SERINV_ITEM_PRINT IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING z_i_serv_docitem zv_igst_sum zi_service_inv_head z_i_serv_journalentry.

    RETURN  select  DISTINCT a.mandt as client,
        a.accountingdocument       as invoiceno,
        a.fiscalyear,
        a.accountingdocumentitem   as item,
        a.documentitemtext         as description,
        a.in_hsnorsaccode          as hsncode,
        a.transactioncurrency      as uom,
         abs( a.amountintransactioncurrency )   as amount,
         abs( b.igstamount )  as igstamount,
        (  coalesce (abs(b.igstamount),0 ) +  coalesce (abs(a.amountintransactioncurrency), 0 ) )  as total
     from z_i_serv_docitem  as a
     inner join z_i_serv_journalentry as d on d.accountingdocument = a.accountingdocument
                                          and d.fiscalyear = a.fiscalyear
     left outer join zv_igst_sum as b on a.accountingdocument = b.invoiceno
                                     and a.fiscalyear = b.fiscalyear
     left outer join  zi_service_inv_head as c on a.accountingdocument = c.invoiceno
                                              and a.fiscalyear = c.fiscalyear
     where
*     a.client = :client
*     and
     a.accountingdocumentitemtype <> 'T'
     and a.financialaccounttype = 'S'
     and d.accountingdocumenttype = 'DR';
  ENDMETHOD.
ENDCLASS.
