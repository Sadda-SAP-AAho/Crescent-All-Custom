CLASS zcl_tbfunc_zcds_hsn DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION zcds_hsn.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TBFUNC_ZCDS_HSN IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
              FOR HDB
              LANGUAGE SQLSCRIPT
              OPTIONS READ-ONLY
              USING zvshipinst_itm  zvdraftqty_cr i_deliverydocumentitem zcds_pccode.

    lt_item = select * from zvshipinst_itm ;

lt_item1 = SELECT a.delivery , a.zqtycrate from
            zvdraftqty_cr as a
           inner join :lt_item as b on a.delivery = b.delivery
           group by a.delivery , a.zqtycrate;



    lt_item4 = select distinct a.delivery,c.consumptiontaxctrlcode as hsncode
*
               from :lt_item as a
               inner join i_deliverydocumentitem as b on a.delivery = b.deliverydocument
               inner join zcds_pccode as c on c.product = b.product and c.plant = b.plant
               group by a.delivery, c.consumptiontaxctrlcode;

*    lt_item3 = select b.mandt , b.bookingno, b.delivery, b.marks, b.containerno,
*                        b.sealno, b.descgoods, b.descgoods1, b.finalseal, b.headerweightunit,
*                        b.headernetweight, b.creationdate,
*                        case
*                        when num_a > 1
*                        then
*                        string_agg( hsncode , ', ' )
*                        else
*                        hsncode
*                        end as hsncode,
*                        case
*                        when num_a > 1
*                        then
*                        string_agg( hsndescp , ', ' )
*                        else
*                        hsndescp
*                        end as hsndescp,
*                        b.address, b.customername, b.customer, b.counconsignee, b.growt,
*                        b.packqty, b.packmattyp, b.wtunit, b.meins
*    from :lt_item2 as a
*    inner join :lt_item as b on a.bookingno = b.bookingno
*    group by b.mandt, num_a, b.hsncode, b.hsndescp, b.bookingno, b.delivery,
*             b.marks, b.containerno, b.sealno, b.descgoods, b.descgoods1, b.finalseal, b.headerweightunit,
*             b.headernetweight, b.creationdate, b.address, b.customername, b.customer,
*             b.counconsignee,
*             b.growt, b.packqty, b.packmattyp, b.wtunit, b.meins;
    lt_item7 = SELECT DISTINCT delivery, COUNT ( HSNCode ) as num_a from :lt_item4
               GROUP BY delivery;

    lt_item8 = SELECT DISTINCT delivery, COUNT ( zqtycrate ) as num_b from :lt_item1
               GROUP BY delivery;

*   DELETE ADJACENT DUPLICATE FROM lt_item3 COMPARING HSNCode HSNDescp;
    lt_item5 = select b.mandt , b.bookingno,b.delivery,b.marks,b.containerno,
               b.sealno,b.descgoods,b.descgoods1, b.finalseal, b.headerweightunit,
               b.headernetweight, b.creationdate,b.address, b.customername, b.customer, b.counconsignee, b.growt,
               b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate,
               a.zqtycrate as packqty
   from :lt_item as b
   left outer join :lt_item1 as a on a.delivery = b.delivery
   GROUP BY b.mandt, b.bookingno,b.delivery,b.marks,b.containerno,
               b.sealno,b.descgoods,b.descgoods1, b.finalseal, b.headerweightunit,
               b.headernetweight, b.creationdate,b.address, b.customername, b.customer, b.counconsignee, b.growt,
               b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate,a.zqtycrate;

   lt_item9 = select b.mandt , b.bookingno, b.delivery, b.marks, b.containerno,
                        b.sealno, b.descgoods, b.descgoods1, b.finalseal, b.headerweightunit,
                        b.headernetweight, b.creationdate, b.address, b.customername,
                        b.customer, b.counconsignee, b.growt,
                        case
                        when num_b > 1
                        then
                        string_agg( packqty , ', ' )
                        else
                        string_agg( packqty, '' )
                        end as packqty,
                        b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate
    from :lt_item5 as b
    left outer join :lt_item8 as a on a.delivery = b.delivery
    group by b.mandt, num_b, b.bookingno, b.delivery,
             b.marks, b.containerno, b.sealno, b.descgoods, b.descgoods1, b.finalseal, b.headerweightunit,
             b.headernetweight, b.creationdate, b.address, b.customername, b.customer,
             b.counconsignee,
             b.growt, b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate;

   lt_item10 = select b.mandt , b.bookingno,b.delivery,b.marks,b.containerno,
               b.sealno,b.descgoods,b.descgoods1, b.finalseal, b.headerweightunit,
               b.headernetweight, b.creationdate,b.address, b.customername, b.customer, b.counconsignee, b.growt,
               b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate, b.packqty, a.hsncode
   from :lt_item9 as b
   left outer join :lt_item4 as a on a.delivery = b.delivery
   GROUP BY b.mandt, b.bookingno,b.delivery,b.marks,b.containerno,
               b.sealno,b.descgoods,b.descgoods1, b.finalseal, b.headerweightunit,
               b.headernetweight, b.creationdate,b.address, b.customername, b.customer, b.counconsignee, b.growt,
               b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate, b.packqty, a.hsncode;

   lt_item11 = select b.mandt , b.bookingno, b.delivery, b.marks, b.containerno,
                        b.sealno, b.descgoods, b.descgoods1, b.finalseal, b.headerweightunit,
                        b.headernetweight, b.creationdate,
                        case
                        when num_a > 1
                        then
                        string_agg( hsncode , ', ' )
                        else
                        string_agg( hsncode , '' )
                        end as hsncode,
                        b.address, b.customername,
                        b.customer, b.counconsignee, b.growt,
                        b.packqty,
                        b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate
    from :lt_item10 as b
    left outer join :lt_item7 as a on a.delivery = b.delivery
    group by b.mandt, a.num_a, b.bookingno, b.delivery,
             b.marks, b.containerno, b.sealno, b.descgoods, b.descgoods1, b.finalseal, b.headerweightunit,
             b.headernetweight, b.creationdate, b.address, b.customername, b.customer,
             b.counconsignee,
             b.growt,b.packqty, b.wtunit, b.meins,b.ShippingBill,b.ShippingBillDate,b.BillingDocument,b.BillingDocumentDate;

return select * from :lt_item11 ;


  endmethod.
ENDCLASS.
