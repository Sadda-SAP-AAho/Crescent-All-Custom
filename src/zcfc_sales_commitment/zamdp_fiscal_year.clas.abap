CLASS zamdp_fiscal_year DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_amdp_marker_hdb.

  CLASS-METHODS : get_year for table FUNCTION ZCDS_Fiscal_F4_Function.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZAMDP_FISCAL_YEAR IMPLEMENTATION.


METHOD get_year by database function for hdb language sqlscript OPTIONS READ-ONLY .

return
    SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2023-24' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

        UNION ALL

        SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2024-25' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

        UNION ALL

        SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2025-26' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

        UNION ALL

        SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2026-27' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

        union all

               SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2027-28' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

        union all


                            SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2028-29' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

       UNION ALL

                  SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2029-30' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

        UNION all

                      SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2030-31' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy

        UNION all

                            SELECT SESSION_CONTEXT('CLIENT') AS client,
               CAST('2031-32' AS NVARCHAR(10)) AS fiscal_year
        FROM dummy;




ENDMETHOD.
ENDCLASS.
