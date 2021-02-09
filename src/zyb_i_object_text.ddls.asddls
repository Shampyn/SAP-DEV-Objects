@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'object type text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZYB_I_OBJECT_TEXT
  as select from zyb_d_object_txt
{

  key objecttype     as Objecttype,
      @Semantics.text: true
      objecttypetext as Objecttypetext
}
