@AbapCatalog.sqlViewName: 'Z_GLCODE_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL CODE-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_GL_CODE_F4
  as select distinct from I_GLAccountText as a
{
  key cast( a.GLAccount as abap.char(10) ) as GLCode,
      @Semantics.text: true
      a.GLAccountName                      as GLName

}
where
  a.Language = 'E'
