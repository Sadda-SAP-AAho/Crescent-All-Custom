CLASS lhc__item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.


    METHODS get_rsrc1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~get_rsrc1.
    METHODS altr_rsrc1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~altr_rsrc1.

    METHODS get_rsrc2 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~get_rsrc2.

    METHODS get_rsrc3 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~get_rsrc3.
    METHODS getplant FOR VALIDATE ON save
      IMPORTING keys FOR _item~getplant.
    METHODS getrsrc FOR VALIDATE ON SAVE
      IMPORTING keys FOR _item~getrsrc.
*    METHODS getrsrc2 FOR VALIDATE ON SAVE
*      IMPORTING keys FOR _item~getrsrc2.
*
*    METHODS getrsrc3 FOR VALIDATE ON SAVE
*      IMPORTING keys FOR _item~getrsrc3.

ENDCLASS.

CLASS lhc__item IMPLEMENTATION.


  METHOD get_rsrc1.

READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY _item
  FIELDS ( Resource_no1 )
  WITH CORRESPONDING  #( keys )
  RESULT DATA(lt_item).


loop at lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).

check <ls_item>-Resource_no1 is NOT INITIAL.
select single  Resource_name from zrsrc_mastr_head where resource_code = @<ls_item>-Resource_no1 into @<ls_item>-Resource_no1_desc.


modify ENTITIES OF Z_I_PLN_MAT_MSTR_HD in LOCAL MODE
ENTITY _item UPDATE
FIELDS ( Resource_no1_desc )
with value #( ( %tky = <ls_item>-%tky Resource_no1_desc = <ls_item>-Resource_no1_desc ) ).

endloop.

  ENDMETHOD.

  METHOD altr_rsrc1.


  READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY _item
  FIELDS ( Alternate_resource_no1 )
  WITH CORRESPONDING  #( keys )
  RESULT DATA(lt_altr1).


loop at lt_altr1 ASSIGNING FIELD-SYMBOL(<ls_item>).

check <ls_item>-Alternate_resource_no1 is NOT INITIAL.
select single  Resource_name from zrsrc_mastr_head where resource_code = @<ls_item>-Alternate_resource_no1 into @<ls_item>-Alternate_resource_no1_desc.


modify ENTITIES OF Z_I_PLN_MAT_MSTR_HD in LOCAL MODE
ENTITY _item UPDATE
FIELDS ( Alternate_resource_no1_desc )
with value #( ( %tky = <ls_item>-%tky Alternate_resource_no1_desc = <ls_item>-Alternate_resource_no1_desc ) ).

endloop.

  ENDMETHOD.

  METHOD get_rsrc2.

  READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY _item
  FIELDS ( Resource_no2 )
  WITH CORRESPONDING  #( keys )
  RESULT DATA(lt_rsrc2).


loop at lt_rsrc2 ASSIGNING FIELD-SYMBOL(<ls_item>).

check <ls_item>-Resource_no2 is NOT INITIAL.
select single  Resource_name from zrsrc_mastr_head where resource_code = @<ls_item>-Resource_no2 into @<ls_item>-Resource_no2_desc.


modify ENTITIES OF Z_I_PLN_MAT_MSTR_HD in LOCAL MODE
ENTITY _item UPDATE
FIELDS ( Resource_no2_desc )
with value #( ( %tky = <ls_item>-%tky Resource_no2_desc = <ls_item>-Resource_no2_desc ) ).

endloop.

  ENDMETHOD.

  METHOD get_rsrc3.

  READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY _item
  FIELDS ( Resource_no3 )
  WITH CORRESPONDING  #( keys )
  RESULT DATA(lt_rsrc3).


loop at lt_rsrc3 ASSIGNING FIELD-SYMBOL(<ls_item>).

check <ls_item>-Resource_no3 is NOT INITIAL.
select single  Resource_name from zrsrc_mastr_head where resource_code = @<ls_item>-Resource_no3 into @<ls_item>-Resource_no3_desc.


modify ENTITIES OF Z_I_PLN_MAT_MSTR_HD in LOCAL MODE
ENTITY _item UPDATE
FIELDS ( Resource_no3_desc )
with value #( ( %tky = <ls_item>-%tky Resource_no3_desc = <ls_item>-Resource_no3_desc ) ).





endloop.

  ENDMETHOD.

  METHOD getPlant.

DATA lt_header_result TYPE TABLE FOR READ RESULT Z_I_PLN_MAT_MSTR_HD.
DATA lt_plant TYPE TABLE FOR READ RESULT Z_I_PLN_MAT_MSTR_HD\_item.

READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY Z_I_PLN_MAT_MSTR_HD
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT lt_header_result.

READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY Z_I_PLN_MAT_MSTR_HD
  BY \_item
  ALL FIELDS
  WITH CORRESPONDING #( lt_header_result )
  RESULT lt_plant.



*data(plant_count) = lines( lt_plant ).
*
*  loop at lt_plant ASSIGNING FIELD-SYMBOL(<ls_plant>).
*
*
*if plant_count = 1.
*
*
*elseif plant_count > 1.
* select single plant from zplnmat_itm_dft WHERE draftentityoperationcode  <> 'L' and requestuuid = @<ls_plant>-Requestuuid and line_no = @<ls_plant>-Line_no and plant = @<ls_plant>-plant into @data(plant).
*if sy-subrc = 0.
*data(lv_check) = 'X'.
*endif.
*
*endif.
*
*  endloop.


sort lt_plant by plant.
delete ADJACENT DUPLICATES FROM lt_plant COMPARING plant.
if sy-subrc = 0.
data(lv_check) = 'X'.
endif.

read table lt_plant into data(ls_plant) INDEX 1.




  if  lv_check is NOT INITIAL.
  APPEND value #( %tky = ls_plant-%tky ) to failed-_hdr.

  APPEND VALUE #( %tky = ls_plant-%tky
                  %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Same Plant Cannot be Repeated'
                   ) ) to reported-_hdr.

endif.
clear : lv_check.
  ENDMETHOD.

  METHOD getRsrc.
DATA lt_header TYPE TABLE FOR READ RESULT Z_I_PLN_MAT_MSTR_HD.
DATA lt_rsrc TYPE TABLE FOR READ RESULT Z_I_PLN_MAT_MSTR_HD\_item.



READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY Z_I_PLN_MAT_MSTR_HD
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT lt_header.

READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
  ENTITY Z_I_PLN_MAT_MSTR_HD
  BY \_item
  ALL FIELDS
  WITH CORRESPONDING #( lt_header )
  RESULT lt_rsrc.

loop at lt_rsrc ASSIGNING FIELD-SYMBOL(<ls_rsrc>).


if <ls_rsrc>-Resource_no1 is NOT INITIAL and <ls_rsrc>-Resource_no2 is NOT INITIAL and <ls_rsrc>-Resource_no3 is INITIAL and <ls_rsrc>-Alternate_resource_no1 is INITIAL
and <ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no2.
data(rsrc) = 'X'.
endif.


if <ls_rsrc>-Resource_no1 is NOT INITIAL and <ls_rsrc>-Resource_no2 is NOT INITIAL and <ls_rsrc>-Resource_no3 is INITIAL and <ls_rsrc>-Alternate_resource_no1 is NOT INITIAL
and (  <ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no2 or  <ls_rsrc>-Resource_no1 = <ls_rsrc>-Alternate_resource_no1 or <ls_rsrc>-Resource_no2 = <ls_rsrc>-Alternate_resource_no1 ).
rsrc = 'X'.
endif.


if <ls_rsrc>-Resource_no1 is NOT INITIAL and <ls_rsrc>-Resource_no2 is NOT INITIAL and <ls_rsrc>-Resource_no3 is NOT   INITIAL and <ls_rsrc>-Alternate_resource_no1 is NOT INITIAL
and ( <ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no2 or <ls_rsrc>-Resource_no2 = <ls_rsrc>-Resource_no3 or <ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no3
or <ls_rsrc>-resource_no1 = <ls_rsrc>-Alternate_resource_no1 or <ls_rsrc>-Resource_no2 = <ls_rsrc>-Alternate_resource_no1 or <ls_rsrc>-Resource_no3 = <ls_rsrc>-Alternate_resource_no1 ).
rsrc = 'X'.
endif.



if <ls_rsrc>-Resource_no1 is NOT INITIAL and <ls_rsrc>-Resource_no2 is NOT INITIAL and <ls_rsrc>-Resource_no3 is NOT   INITIAL and <ls_rsrc>-Alternate_resource_no1 is  INITIAL
and ( <ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no2 or <ls_rsrc>-Resource_no2 = <ls_rsrc>-Resource_no3 or <ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no3
 ).
rsrc = 'X'.
endif.



if <ls_rsrc>-Resource_no1 is NOT INITIAL and <ls_rsrc>-Resource_no3 is NOT INITIAL and  <ls_rsrc>-Resource_no2 is INITIAL and <ls_rsrc>-Alternate_resource_no1 is INITIAL and
<ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no3.
rsrc = 'X'.
endif.

if <ls_rsrc>-Resource_no1 is NOT INITIAL and <ls_rsrc>-Resource_no3 is NOT INITIAL and  <ls_rsrc>-Resource_no2 is INITIAL and <ls_rsrc>-Alternate_resource_no1 is not INITIAL and
(  <ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no3 or <ls_rsrc>-Resource_no1 = <ls_rsrc>-Alternate_resource_no1 or <ls_rsrc>-Resource_no3 = <ls_rsrc>-Alternate_resource_no1 ).
rsrc = 'X'.
endif.

if <ls_rsrc>-Resource_no2 is NOT INITIAL  and <ls_rsrc>-Resource_no3 is NOT INITIAL and <ls_rsrc>-Resource_no1 is INITIAL and <ls_rsrc>-Alternate_resource_no1 is INITIAL and
<ls_rsrc>-Resource_no1 = <ls_rsrc>-Resource_no3.
rsrc = 'X'.
endif.

if <ls_rsrc>-Resource_no2 is NOT INITIAL  and <ls_rsrc>-Resource_no3 is NOT INITIAL and <ls_rsrc>-Resource_no1 is INITIAL and <ls_rsrc>-Alternate_resource_no1 is not INITIAL and
( <ls_rsrc>-Resource_no2 = <ls_rsrc>-Resource_no3 or <ls_rsrc>-Resource_no2 =  <ls_rsrc>-Alternate_resource_no1 or <ls_rsrc>-Resource_no3 =  <ls_rsrc>-Alternate_resource_no1 ).
rsrc = 'X'.
endif.
ENDLOOP.


  check rsrc is NOT INITIAL.

  APPEND value #( %tky = <ls_rsrc>-%tky ) to failed-_hdr.

  APPEND VALUE #( %tky = <ls_rsrc>-%tky
                  %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Same Resource Code Not Allowed'
                   ) ) to reported-_hdr.





  ENDMETHOD.



ENDCLASS.

CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.
    METHODS getmatdesc FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~getmatdesc.
    METHODS checkcombination FOR VALIDATE ON SAVE
      IMPORTING keys FOR _hdr~checkcombination.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_authorizations.


  ENDMETHOD.

  METHOD getMatDesc.

  READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD in local mode
  entity _hdr
  FIELDS ( Material_code )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_matcode).


loop at lt_matcode ASSIGNING FIELD-SYMBOL(<ls_mat>).


select single productname from ZMaterial_F4_help  where Product = @<ls_mat>-Material_code  into @<ls_mat>-Material_desc.
check <ls_mat>-Material_desc is not INITIAL.
MODIFY ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
ENTITY _hdr UPDATE
FIELDS ( Material_desc )
with value #( ( %tky = <ls_mat>-%tky Material_desc = <ls_mat>-Material_desc ) ).


endloop.



  ENDMETHOD.

 METHOD checkcombination.

 READ ENTITIES OF Z_I_PLN_MAT_MSTR_HD IN LOCAL MODE
             ENTITY _hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY Z_I_PLN_MAT_MSTR_HD
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE concat( a~Material_code , b~Plant )
    FROM Z_I_PLN_MAT_MSTR_HD AS a
    INNER JOIN Z_I_PLN_MAT_MSTR_ITM AS b ON a~Requestuuid = b~Requestuuid
    WHERE a~Material_code = @gfs_header-Material_code
    AND b~Plant = @gfs_item-Plant
    INTO @DATA(ls_comb).

    IF ls_comb IS NOT INITIAL.

      SELECT SINGLE concat( a~Material_code , b~Plant )
      FROM ZPLN_MAT_MSTR_HD AS a
      INNER JOIN ZPLN_MAT_MST_ITM AS b ON a~Requestuuid = b~Requestuuid
      WHERE a~Material_code = @gfs_header-Material_code
      AND b~Plant = @gfs_item-Plant
      INTO @DATA(ls_comb1).

      IF ls_comb1 IS NOT INITIAL.
        DATA(lv_msg1) = |Material Code–Plant combination already exists|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-_hdr.
      ENDIF.
    ENDIF.

 ENDMETHOD.


ENDCLASS.
