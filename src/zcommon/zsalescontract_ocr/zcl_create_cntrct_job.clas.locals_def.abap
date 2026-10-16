CONSTANTS: headerName  TYPE string VALUE 'x-functions-key',
           headerValue TYPE string VALUE 'DMS-FUNCTION-KEY',
           container   TYPE string VALUE 'DMS-CONTAINER'.


TYPES: BEGIN OF ty_error_res,
         error TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
       END OF ty_error_res.


TYPES: BEGIN OF ty_upload_res,
         isSuccess TYPE string,
         message   TYPE string,
         data      TYPE string,
       END OF ty_upload_res.
