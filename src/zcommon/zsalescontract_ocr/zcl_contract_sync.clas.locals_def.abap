*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section


TYPES: BEGIN OF ty_sc_payload,
         docid      TYPE string,
         salescontractno  TYPE string,
       END OF ty_sc_payload.

    TYPES:
      BEGIN OF ty_response,
        message            TYPE string,
        status             TYPE string,
      END OF ty_response.
