@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'components basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZYB_I_COMPONENTS
  as select from I_CustABAPObjDirectoryEntry
  association [0..*] to zyb_table_cust    as _fields on $projection.ABAPObject = _fields.ABAPObject
  association [0..*] to zyb_aplo_cust     as _subObj on $projection.ABAPObject = _subObj.object
  association [0..*] to zyb_domain_cust   as _domain on $projection.ABAPObject = _domain.DomainObj
  association [0..*] to zyb_ddls_custom   as _ddls   on $projection.ABAPObject = _ddls.DataDefinition
  association [0..*] to zyb_msag_cust     as _msag   on $projection.ABAPObject = _msag.ClassName
  association [0..*] to zyb_srvd_cust     as _srvd   on $projection.ABAPObject = _srvd.ServiceDefinition
  association [1..1] to zyb_dtel_cust     as _dtel   on $projection.ABAPObject = _dtel.Data_element
  association [1..1] to zyb_srvb_cust     as _srvb   on $projection.ABAPObject = _srvb.ServiceBinding
  association [0..1] to ZYB_I_OBJECT_TEXT as _text   on $projection.ABAPObjectType = _text.Objecttype
{
  key ABAPObjectCategory,
      // @ObjectModel.text.association: '_text'
      //@ObjectModel.text.element: ['Objecttypetext']
  key ABAPObjectType,
  key ABAPObject,
      ABAPObjectResponsibleUser,
      ABAPObjectIsDeleted,
      ABAPPackage,
      ABAPSoftwareComponent,
      _text.Objecttypetext,
      case ABAPObjectType
      when 'TABL' then ' '
      else 'X'
      end  as IsTable,
      case ABAPObjectType
      when 'APLO' then ' '
      else 'X'
      end  as IsAPLO,
      case ABAPObjectType
      when 'DOMA' then ' '
      else 'X'
      end  as IsDomain,
      case ABAPObjectType
      when 'DDLS' then ' '
      else 'X'
      end  as IsDDLS,
      case ABAPObjectType
      when 'MSAG' then ' '
      else 'X'
      end  as IsMSAG,
      case ABAPObjectType
      when 'SRVD' then ' '
      else 'X'
      end  as IsSRVD,
      case ABAPObjectType
       when 'DTEL' then ' '
       else 'X'
       end as IsDTEL,
      case ABAPObjectType
      when 'SRVB' then ' '
      else 'X'
      end  as IsSRVB,
      /* Associations */
      _CustABAPPackage,
      _fields,
      _subObj,
      _domain,
      _ddls,
      _msag,
      _srvd,
      _dtel,
      _srvb,
      _text
}
