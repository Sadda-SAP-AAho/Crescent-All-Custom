CLASS zcl_pur_reg_qc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztf_purchase_reg_12.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PUR_REG_QC IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING zi_purchase_reg_11 Z_I_PURCHASE_REG_12 Z_I_PURCHASE_REG_12_1.

    lt_item = select a.mandt, a.materialdocument, a.materialdocumentitem, a.materialdocumentyear,
                     c.InspectionCodeText
                from zi_purchase_reg_11 as a
                INNER JOIN Z_I_PURCHASE_REG_12 as b on b.InspectionLot = a.InspectionLot
                INNER JOIN Z_I_PURCHASE_REG_12_1       as c on c.InspectionCatalog   = b.insplotusagedecisioncatalog
                                                          and c.inspectioncodegroup = b.insplotusagedecisioncodegroup
                                                          and c.inspectioncode      = b.inspectionlotusagedecisioncode
                                                          and c.language            = 'E';

    return  select *
            from :lt_item
            order by materialdocumentyear asc, materialdocument asc, materialdocumentitem asc;

  endmethod.
ENDCLASS.
