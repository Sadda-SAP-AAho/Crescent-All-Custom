CLASS zcl_so_bom_comp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS : get_bom_explosion FOR TABLE FUNCTION ztf_socomptbom.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SO_BOM_COMP IMPLEMENTATION.


METHOD get_bom_explosion BY DATABASE FUNCTION FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING zi_so_compreq
                               z_materialbomlinkdex
                               z_billofmaterialitemdex_3
                               z_product
                               zproductgroupmap
                               z_productgrouptext_2
                               z_materialstock_2
                               z_purchaserequisitionitemapi01
                               z_productdescription
                               z_materialdocumentitem_2
                               zdt_pp_matinffld.
    -- Declare variables
       DECLARE lv_client nvarchar(3) = session_context('CLIENT');
       DECLARE lv_max_level int DEFAULT 10;
       DECLARE lv_current_level int = 1;
       DECLARE lv_row_count int;
       DECLARE lv_error_msg nvarchar(2000);

       -- Temporary table for sales order items
       lt_so_items = SELECT
                       :lv_client as client,
                       salesorderno,
                       sorownumber,
                       materialno,
                       plant,
                       soopenqty,
                       orderquantityunit
                     FROM zi_so_compreq
                     ORDER BY sorownumber;

       -- initialize bom explosion table with top level items
       lt_bom_explosion = SELECT
                            :lv_client as client,
                            salesorderno,
                            sorownumber,
                            materialno as original_materialno,
                            materialno as parentmaterial,
                            plant,
                            soopenqty as original_soopenqty,
                            soopenqty as parentqty,
                            orderquantityunit as parentunit,
                            1 as level,
                            '' as processed_boms -- initialize empty string for bom tracking
                          FROM :lt_so_items
                          ORDER BY sorownumber;

       -- recursive processing using a loop
       WHILE :lv_current_level <= :lv_max_level DO
         -- Get next level components
         lt_components =
         SELECT DISTINCT
           CAST(b.client AS nvarchar(3)) as client,
          CAST(b.salesorderno AS nvarchar(10)) as salesorderno,
          CAST(b.sorownumber AS nvarchar(6)) as sorownumber,
          CAST(b.original_materialno AS nvarchar(40)) as original_materialno,
          CAST(c.billofmaterialcomponent AS nvarchar(40)) as parentmaterial,
          CAST(b.plant AS nvarchar(4)) as plant,
          CAST(b.original_soopenqty AS decimal(31,8)) as original_soopenqty,
          CAST(c.billofmaterialitemquantity * b.parentqty AS decimal(31,8)) as parentqty,
          CAST(c.billofmaterialitemunit AS nvarchar(3)) as parentunit,
          CAST(b.level + 1 AS int) as level,
          CAST(
            CASE
              WHEN b.processed_boms = '' THEN m.billofmaterial
              ELSE b.processed_boms || ',' || m.billofmaterial
            END AS nvarchar(1000)) as processed_boms
           FROM :lt_bom_explosion as b
           JOIN z_materialbomlinkdex as m ON
             m.material = b.parentmaterial AND
             m.plant = b.plant AND
             m.billofmaterialvariant = '01' AND
             m.billofmaterialvariantusage = '1' AND
             m.billofmaterialcategory = 'M'
           JOIN z_billofmaterialitemdex_3 AS c ON
             c.billofmaterial = m.billofmaterial AND
             c.billofmaterialvariant = m.billofmaterialvariant AND
             c.billofmaterialcategory = m.billofmaterialcategory
           WHERE b.level = :lv_current_level
           AND (b.processed_boms NOT LIKE '%' || m.billofmaterial || '%' OR b.processed_boms = '')
           ORDER BY b.sorownumber;

         -- Check if components were found
         SELECT COUNT(*) INTO lv_row_count FROM :lt_components;

         -- Exit if no more components found
         IF :lv_row_count = 0 THEN
           break;
         END if;

         -- Create a temporary table with the exact structure we need
      lt_temp = SELECT
                 CAST(client AS nvarchar(3)) as client,
                 CAST(salesorderno AS nvarchar(10)) as salesorderno,
                 CAST(sorownumber AS nvarchar(6)) as sorownumber,
                 CAST(original_materialno AS nvarchar(40)) as original_materialno,
                 CAST(parentmaterial AS nvarchar(40)) as parentmaterial,
                 CAST(plant AS nvarchar(4)) as plant,
                 CAST(original_soopenqty as decimal(31,8)) as original_soopenqty,
                 CAST(parentqty AS decimal(31,8)) as parentqty,
                 CAST(parentunit AS nvarchar(3)) as parentunit,
                 CAST(level AS int) as level,
                 CAST(processed_boms AS nvarchar(1000)) as processed_boms
               FROM :lt_bom_explosion
               WHERE 1 = 0; -- Empty result set


*         -- Add components to result using proper UNION ALL syntax
         lt_bom_explosion = SELECT * FROM :lt_bom_explosion
                            UNION ALL
                            SELECT
                           CAST(c.client AS nvarchar(3)),
                           CAST(c.salesorderno AS nvarchar(10)),
                           CAST(c.sorownumber AS nvarchar(6)),
                           CAST(c.original_materialno AS nvarchar(40)),
                           CAST(c.parentmaterial AS nvarchar(40)),
                           CAST(c.plant AS nvarchar(4)),
                           CAST(c.original_soopenqty AS decimal(31,8)),
                           CAST(c.parentqty AS decimal(31,8)),
                           CAST(c.parentunit AS nvarchar(3)),
                           CAST(c.level AS int),
                           CAST(c.processed_boms AS nvarchar(1000))
                         FROM :lt_components c;

         -- Increment level counter
         lv_current_level = :lv_current_level + 1;
       END while;

*-------------------------------------------------------------------------
       lt_bom_explosion_with_info =
      SELECT
        b.client,
        b.salesorderno,
        b.sorownumber,
        b.original_soopenqty,
        b.original_materialno,
        b.parentmaterial,
        b.plant,
        b.parentqty,
        b.parentunit,
        b.level,
        b.processed_boms,
        -- Add the material info fields
        m.pltpcdboxsize,
        m.boltsize,
        m.qtypalpcdbox,
        m.pcspack,
        m.qtyboltunitcons,
        m.qtyboltunitcons * b.parentqty as bolt_reqd,
        m.qtypalpcdbox * b.parentqty as pallet_reqd
      FROM :lt_bom_explosion as b
      LEFT JOIN zdt_pp_matinffld as m ON m.product = b.parentmaterial;
*--------------------------------------------------------------------------------



       -- Final result with product info
       lt_final_components =
         SELECT
           b.client,
           b.salesorderno,
           b.sorownumber,
           b.original_soopenqty as soqty,
           b.original_materialno as materialno,
           b.plant,
           b.parentmaterial as componentmaterial,
           b.parentqty as componentqty,
           b.parentunit as componentunit,
           p.productgroup,
           p.producttype,
           pg.productgroupname as component_material_group_name,
*           coalesce(s.matlwrhsstkqtyinmatlbaseunit, 0)  as component_stock,

           coalesce(
      (SELECT SUM(s2.matlwrhsstkqtyinmatlbaseunit)
       FROM z_materialstock_2 AS s2
       WHERE s2.material = b.parentmaterial
         AND s2.plant = b.plant
         AND s2.mandt = b.client
         AND s2.inventorystocktype = '01'), 0) as component_stock,
    (SELECT materialbaseunit FROM (
       SELECT materialbaseunit, ROW_NUMBER() OVER (ORDER BY  material) as rn
       FROM z_materialstock_2
       WHERE material = b.parentmaterial
         AND plant = b.plant
         AND mandt = b.client
         AND inventorystocktype = '01'
     ) WHERE rn = 1) as materialbaseunit,

           b.level,
           b.pltpcdboxsize,
           b.boltsize,
           b.qtypalpcdbox ,
           b.pcspack ,
           b.qtyboltunitcons ,
           b.bolt_reqd ,
           b.pallet_reqd ,
           CASE WHEN EXISTS (
             SELECT 1 FROM z_materialbomlinkdex as m
             WHERE m.mandt = b.client
               AND m.material = b.parentmaterial
               AND m.plant = b.plant
               AND m.billofmaterialvariant = '01'
               AND m.billofmaterialvariantusage = '1'
               AND m.billofmaterialcategory = 'M'
           ) THEN false ELSE true END AS isfinalcomponent
*         FROM :lt_bom_explosion AS b
         FROM :lt_bom_explosion_with_info AS b
         LEFT JOIN z_product AS p ON p.mandt = b.client
               AND p.product = b.parentmaterial
         LEFT JOIN z_productgrouptext_2 AS pg ON pg.productgroup = p.productgroup
                                              AND pg.LANGUAGE = session_context('LOCALE_SAP')
*         LEFT JOIN z_materialstock_2 AS s ON s.material = b.parentmaterial
*                                         AND s.plant = b.plant
*                                         AND s.mandt = b.client
*                                         AND s.inventorystocktype = '01'


         WHERE EXISTS (
           SELECT 1 FROM zproductgroupmap as pg
*        WHERE pg.mandt = b.client and
              where pg.productgroup = p.productgroup
         );

-- First get basic pr info (number and item)
lt_pr_basic = SELECT DISTINCT
                pr.purchaserequisition,
                pr.purchaserequisitionitem,
                pr.material,
                pr.plant
              FROM :lt_final_components AS fc
              JOIN z_purchaserequisitionitemapi01 AS pr ON pr.material = fc.componentmaterial
                                                       AND pr.plant = fc.plant
                                                       AND TRIM(pr.requisitionername) = fc.salesorderno
*                                                       AND TRIM(pr.requirementtracking) = LPAD(fc.sorownumber, 10, '0');
                                                       AND LPAD(TRIM(pr.requirementtracking), 10, '0') = LPAD(fc.sorownumber, 10, '0');

-- Then get full pr details in separate query
lt_pr_full = SELECT
               pr.mandt as client,
               pr.purchaserequisition,
               pr.purchaserequisitionitem,
               pr.creationdate,
               pr.requestedquantity,
               pr.baseunit,
               pr.orderedquantity,
               pr.purchasingdocument,
               pr.purchasingdocumentitem
             FROM z_purchaserequisitionitemapi01 AS pr
             JOIN :lt_pr_basic AS pb ON pr.purchaserequisition = pb.purchaserequisition
                                    AND pr.purchaserequisitionitem = pb.purchaserequisitionitem;

 lt_pr_full1 =
    SELECT *
    FROM :lt_pr_full
    WHERE purchasingdocument     IS NOT NULL
       AND purchasingdocument     <> ''
       AND purchasingdocumentitem IS NOT NULL
       AND purchasingdocumentitem <> '';

 lt_po_quantities = SELECT
                     po.client,
                     po.purchasingdocument as purchaseorder,
                     po.purchasingdocumentitem as purchaseorderitem,
                     SUM(md.quantityinbaseunit) as quantityinbaseunit
                   FROM z_materialdocumentitem_2 AS md

                   LEFT JOIN :lt_pr_full1 AS po ON md.purchaseorder = po.purchasingdocument
                                             AND md.purchaseorderitem = po.purchasingdocumentitem
                                             AND md.mandt = po.client
*                   WHERE po.purchasingdocument IS NULL
*                     AND po.purchasingdocumentitem IS NULL
                     GROUP BY po.client,po.purchasingdocument, po.purchasingdocumentitem;

return
  SELECT
      fc.client,
      fc.salesorderno,
      fc.sorownumber,
      fc.level,
      fc.componentmaterial,
      pd.productdescription as componentmaterialname,
      fc.materialno,
      fc.plant,
      fc.soqty,
      fc.componentqty,
      fc.componentunit,
      fc.productgroup,
      fc.producttype,
      fc.component_material_group_name,
      fc.component_stock,
      fc.materialbaseunit,
      pb.purchaserequisition as purchaserequisition,
      pb.purchaserequisitionitem as purchaserequisitionitem,
      pf.creationdate as pr_creationdate,
      pf.requestedquantity as pr_qty,
      pf.baseunit,
      pf.orderedquantity as ordered_quantity,
      pf.purchasingdocument as purchaseorder,
      pf.purchasingdocumentitem as purchaseorderitem,

*         coalesce(pq.quantityinbaseunit, 0) as quantityinbaseunit,

       CASE
        WHEN pf.purchasingdocument IS NULL and pf.purchasingdocumentitem IS NULL
        THEN 0
        ELSE coalesce(pq.quantityinbaseunit, 0)
      END as quantityinbaseunit,
          -- calculate open po quantity: ordered quantity - quantity received
          CASE
            WHEN pf.orderedquantity IS NOT NULL AND pq.quantityinbaseunit IS NOT NULL
              THEN pf.orderedquantity - pq.quantityinbaseunit
            WHEN pf.orderedquantity IS NOT NULL
              THEN pf.orderedquantity
            ELSE 0
          END as open_po_qty,

           -- calculate open pr quantity: pr_qty - ordered_quantity
          CASE
            WHEN pf.orderedquantity IS NOT NULL AND pf.requestedquantity IS NOT NULL
              THEN pf.requestedquantity - pf.orderedquantity
            WHEN pf.requestedquantity IS NOT NULL
              THEN pf.requestedquantity
            ELSE 0
          END as open_pr_qty,

      fc.isfinalcomponent,
      fc.pltpcdboxsize as pallet_pcd_box_size,
      fc.BOLTSIZE as bolt_size,
      fc.qtypalpcdbox as qty_of_pallet_pcd_box,
      fc.pcspack as std_no_of_pcs_pack,
      fc.qtyboltunitcons as qty_of_bolt,
      fc.bolt_reqd,
      fc.pallet_reqd,
      '' as shop_floor_no
  FROM :lt_final_components AS fc
  LEFT JOIN :lt_pr_basic AS pb ON pb.material = fc.componentmaterial
                              AND pb.plant = fc.plant
  LEFT JOIN :lt_pr_full AS pf ON pf.purchaserequisition = pb.purchaserequisition
                             AND pf.purchaserequisitionitem = pb.purchaserequisitionitem
  LEFT JOIN z_productdescription AS pd ON pd.mandt = fc.client
                                      AND pd.product = fc.componentmaterial
                                      AND pd.language = session_context('LOCALE_SAP')
  LEFT JOIN :lt_po_quantities as pq on pq.purchaseorder = pf.purchasingdocument
                                      AND pq.purchaseorderitem = pf.purchasingdocumentitem
                                      AND pq.client = pf.client
                                      ORDER BY fc.sorownumber;

  ENDMETHOD.
ENDCLASS.
