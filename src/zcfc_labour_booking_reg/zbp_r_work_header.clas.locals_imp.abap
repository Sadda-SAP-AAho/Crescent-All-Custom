CLASS LHC_ZR_WORK_HEADER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Zr_Work_Header
        RESULT result,
      fill_plant_name FOR DETERMINE ON MODIFY
            IMPORTING entities FOR Zr_Work_Header~fill_plant_name.
ENDCLASS.

CLASS LHC_ZR_WORK_HEADER IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD fill_plant_name.

      data lt_plant TYPE TABLE FOR READ RESULT zr_work_header.

      READ ENTITIES OF zr_work_header in LOCAL MODE
      entity zr_work_header fields ( PlantCode WorkCode )
      WITH CORRESPONDING #( entities ) result lt_plant.

      LOOP AT lt_plant into data(ls_plant).

        SELECT SINGLE from i_plant FIELDS PlantName
        where Plant = @ls_plant-PlantCode
        into ( @ls_plant-PlantName ).

        if sy-subrc eq 0.
           modify lt_plant from ls_plant.
        ENDIF.

      ENDLOOP.

      data lt_update TYPE TABLE FOR update zr_work_header.
      lt_update = CORRESPONDING #( lt_plant ).

      MODIFY ENTITIES OF zr_work_header in LOCAL MODE
      ENTITY zr_work_header UPDATE FIELDS ( PlantName )
      with lt_update REPORTED data(lt_report).

      reported-zr_work_header = CORRESPONDING #( lt_report-zr_work_header ).



  ENDMETHOD.

ENDCLASS.
