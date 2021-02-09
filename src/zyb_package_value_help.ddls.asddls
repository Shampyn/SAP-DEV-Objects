@EndUserText.label: 'package value help'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZYB_PACKAGE_VALUE_HELP
  as select from I_CustABAPPackage
{
  key ABAPPackage
}
