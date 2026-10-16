CLASS zcl_get_bom_components DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_bom_component FOR TABLE FUNCTION zr_bom_components.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GET_BOM_COMPONENTS IMPLEMENTATION.


  METHOD get_bom_component BY DATABASE FUNCTION
                FOR HDB
                LANGUAGE SQLSCRIPT
                OPTIONS READ-ONLY
                USING zr_bomproductionversion i_productionversion i_billofmaterialitemtp_2 i_billofmaterialheaderdex_2
                      i_product.

*** variable declaration
    declare lv_count integer;
    declare lv_level integer;
***initialize the BOM Level = 1
    lv_level = 1;
***select the data for 1st Level BOM

    root_bom = select
                  _prodversion.mandt,
                  _productionversion.material                   as material,
                  _productionversion.plant                       as plant,
*                  _productionversion.productionversion           as productionversion,
                  _productionversion.validitystartdate           as validitystartdate,
                  _productionversion.validityenddate             as validityenddate,
                  _billofmaterial.bomheaderquantityinbaseunit    as bomheaderqty,
                  _billofmaterial.bomheaderbaseunit              as bomheaderqtyunit,
                   :lv_level                                     as bomlevel,
                    _productionversion.material                  as parent,
                  _billofmaterialitem.billofmaterialcomponent    as component,
                  _billofmaterialitem.billofmaterialitemquantity as bomitemqty,
                  _billofmaterialitem.billofmaterialitemunit     as bomitemqtyunit,
*                  _billofmaterialitem.componentscrapinpercent    as componentscrapinpercent,
*                  _billofmaterialitem.validitystartdate          as bomvaliditystartdate,
*                  _billofmaterialitem.validityenddate            as bomvalidityenddate,
*                  _productionversion.materialbaseunit            as baseunit,
*                  _billofmaterialitem.materialiscoproduct        as coproduct,
                  _product.productgroup                          as productgroup


                 from zr_bomproductionversion      as _prodversion
                 inner join   i_productionversion  as _productionversion on  _productionversion.material          = _prodversion.material
                                                                         and _productionversion.plant             = _prodversion.plant
                                                                         and _productionversion.productionversion = _prodversion.productionversion

                 inner join   i_billofmaterialitemtp_2 as _billofmaterialitem on  _billofmaterialitem.material = _prodversion.material
                                                                              and _billofmaterialitem.plant    = _prodversion.plant

                 inner join   i_billofmaterialheaderdex_2 as _billofmaterial  on  _billofmaterial.billofmaterial = _billofmaterialitem.billofmaterial
                                                                              and _billofmaterial.billofmaterialcategory = _billofmaterialitem.billofmaterialcategory

                 inner join  i_product                    as _product         on _product.product = _billofmaterialitem.billofmaterialcomponent

                 where _prodversion.mandt       = :mandt
                      and _prodversion.material = :p_matnr
                      and _prodversion.plant    = :p_werks;

***pass the selected BOM data into OUT_BOM
    out_bom = SELECT * FROM :root_bom;
***select the components from the 1st Level BOM
    components = SELECT component, plant from :root_bom;
***select the count of components from the 1st Level BOM
    SELECT COUNT ( * ) into lv_count from :components;
***if the components are found, check for next level BOM data
    while :lv_count > 0 do
***increment the BOM level
        lv_level = lv_level + 1;
***select the data for the BOM of components
        child_bom = select
                  _prodversion.mandt,
                  _productionversion.material                    as material,
                  _productionversion.plant                       as plant,
*                  _productionversion.productionversion           as productionversion,
                  _billofmaterialitem.validitystartdate           as validitystartdate,
                  _billofmaterialitem.validityenddate             as validityenddate,
                  _billofmaterial.bomheaderquantityinbaseunit    as bomheaderqty,
                  _billofmaterial.bomheaderbaseunit              as bomheaderqtyunit,
                   :lv_level                                     as bomlevel,
                    _productionversion.material                  as parent,
                  _billofmaterialitem.billofmaterialcomponent    as component,
                  _billofmaterialitem.billofmaterialitemquantity as bomitemqty,
                  _billofmaterialitem.billofmaterialitemunit     as bomitemqtyunit,
*                  _billofmaterialitem.componentscrapinpercent    as componentscrapinpercent,
*                  _billofmaterialitem.validitystartdate          as bomvaliditystartdate,
*                  _billofmaterialitem.validityenddate            as bomvalidityenddate,
*                  _productionversion.materialbaseunit            as baseunit,
*                  _billofmaterialitem.materialiscoproduct        as coproduct,
                  _product.productgroup                          as productgroup


                 from zr_bomproductionversion      as _prodversion
                 inner join   i_productionversion  as _productionversion on  _productionversion.material          = _prodversion.material
                                                                         and _productionversion.plant             = _prodversion.plant
                                                                         and _productionversion.productionversion = _prodversion.productionversion

                 inner join   i_billofmaterialitemtp_2 as _billofmaterialitem on  _billofmaterialitem.material = _prodversion.material
                                                                              and _billofmaterialitem.plant    = _prodversion.plant

                 inner join   i_billofmaterialheaderdex_2 as _billofmaterial  on  _billofmaterial.billofmaterial = _billofmaterialitem.billofmaterial
                                                                              and _billofmaterial.billofmaterialcategory = _billofmaterialitem.billofmaterialcategory

                 inner join  i_product                    as _product         on _product.product = _billofmaterialitem.billofmaterialcomponent

                 inner join :components as b on _productionversion.material = b.component and _productionversion.plant    = :p_werks;

***select the components from the above selected child BOM
        components = SELECT component, plant from :child_bom;
***select the count of components from the above selected child BOM
*** if the count of component from this level is 0, then while loop will be terminated
        SELECT COUNT ( * ) into lv_count from :components;
***merge the BOM data (OUT_BOM) with the components from current level in selection
        out_bom = select * from :out_bom
                    union all
                  select * from :child_bom;
    end while;


      return select * from :out_bom ;

  endmethod.
ENDCLASS.
