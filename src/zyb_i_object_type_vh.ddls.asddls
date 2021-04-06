@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Object Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZYB_I_OBJECT_TYPE_VH
  as select distinct from I_CustABAPObjDirectoryEntry

  association [0..1] to ZYB_I_OBJECT_TEXT as _ObjectText on $projection.ABAPObjectType = _ObjectText.Objecttype

{
      @EndUserText.label: 'Object Type'
  key ABAPObjectType,
      @Semantics.text: true
      @EndUserText.label: 'Object Type Text'
      _ObjectText.Objecttypetext

}
