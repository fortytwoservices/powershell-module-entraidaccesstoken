# Changelog

## [2.10.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.9.0...v2.10.0) (2025-08-20)


### Features

* Add user interactive token profile ([11fdf50](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/11fdf50fcf856bb826d5d037d39ceafabc39cb96))

## [2.9.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.8.0...v2.9.0) (2025-06-04)


### Features

* Add ConvertFrom-EntraIDAccessToken and Write-EntraIDAccessToken functions for simplified output ([5a76007](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/5a760079aa7420cf99eb60bb6d8633d5ca5857f7))

## [2.8.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.7.0...v2.8.0) (2025-06-03)


### Features

* Add azp parameter verification to Confirm-EntraIDAccessToken ([62f5c52](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/62f5c52e719a4d4f69e26db2f6b14dad9225bff8))
* Add roles parameter and validation to Confirm-EntraIDAccessToken ([ec78860](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/ec788602e5d0ae859a2dc21e3ba9d92e3137ab15))
* Add working Confirm-EntraIDAccessToken ([f5556f0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/f5556f034b532672643446ecd76521e2fc4677ef))


### Bug Fixes

* Add verification of number of dots to Get-EntraIDAccessTokenPayload ([392a404](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/392a404ad562bd3955289221d22aa10820b7313e))

## [2.7.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.6.3...v2.7.0) (2025-04-24)


### Features

* Add Get-EntraIDAccessTokenSecureString ([a4a7e51](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/a4a7e517c7f4ad1e3f640e32498e1de3ad654b81))

## [2.6.3](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.6.2...v2.6.3) (2025-04-22)


### Bug Fixes

* Handle missing ENV:SYSTEM_ACCESSTOKEN better for DevOps federated credential ([ae6933c](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/ae6933c02769e9a7e987c513e7b9714920dd0edc))

## [2.6.2](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.6.1...v2.6.2) (2025-04-04)


### Features

* Add switch option to use OIDCRequestURI ([70df733](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/70df733ac7e97a754db9786186580bbd8e867ee7))
* Move OIDC token retrieval ([4c1bd9e](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/4c1bd9e2d00f637f1a1cd13ef25ef94cf89986eb))
* Remove Get-OIDCToken function ([591eac3](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/591eac33aaf95fb790a11cc12cb5f14b66551d74))
* Remove OIDCRequestUri parameter ([d83ae75](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/d83ae75eebeca589d34c4d4eb2cd7e8940e30833))
* Update error handling for missing OIDC request URI and service connection ID ([ec13f2f](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/ec13f2f0770cc2a901568b5b9cdf28c1a9785710))
* Use OIDCREQUESTURI instead of env:idToken ([19e981b](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/19e981b3137deb6f27fcc1010247957eeeeeb5a9))


### Bug Fixes

* Do not break existing implementations ([3fbf15e](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/3fbf15e4010b41089ece2a2d35e814352e1890eb))

## [2.6.1](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.6.0...v2.6.1) (2025-03-14)


### Bug Fixes

* Fix for federated credentials using uai towards app reg ([f6f181d](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/f6f181d9cad206c72e181846a8b78a458420be44))

## [2.6.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.5.1...v2.6.0) (2025-03-06)


### Features

* Add default values for tenantid and clientid for Azure DevOps federerated credential ([27c5a4f](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/27c5a4febcac089bdcdcf7a1f0ae4a6120b5d2b8))

## [2.5.1](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.5.0...v2.5.1) (2025-02-21)


### Bug Fixes

* Fix for using Key Storage Provider instead of only legacy CSP ([e63eb70](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/e63eb70ab9e6f511b70981c8182f0b6ad0cdb819))

## [2.5.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.4.0...v2.5.0) (2025-02-07)


### Features

* Add support for Azure PowerShell Session (simple wrapper of get-azaccesstoken). This way we can utilize this module in a standard fashion for these situations too. ([57e140e](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/57e140e4bba2fc8d9f333e5c00fe72feee0a5cec))

## [2.4.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.3.1...v2.4.0) (2025-02-06)


### Features

* Add function app support through Add-EntraIDFunctionAppMSIAccessTokenProfile ([89e4c5a](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/89e4c5ab7b9b6477bdb55e91c073a5e94c7c7c8f))


### Bug Fixes

* Missing default parameter set name for devops fed cred profile ([90f17b4](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/90f17b4d0b0b6ca45793749279ab85c91e4a5f67))

## [2.3.1](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.3.0...v2.3.1) (2025-01-29)


### Bug Fixes

* Certificate based auth now working ([9bda832](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/9bda832ac383ab118507cdbdeae168ed22df6c19))

## [2.3.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.2.0...v2.3.0) (2025-01-28)


### Features

* Add Get-EntraIDAccessTokenHasRoles for ensuring access to certain scopes ([5b6ec58](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/5b6ec5882116265e92547932c7cb9aa81461d9d9))
* Add github federated credential support ([e586d88](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/e586d88199b28875b8377244e81fa9a9630d94e4))
* Simplify code with using the same cmdlet (Get-EntraIDFederatedCredentialAccessToken) for everyone using federated credentials ([9f5daea](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/9f5daea91ba2714f9effcbd96520dac47df0d383))


### Bug Fixes

* Allow Get-EntraIDAccessTokenProfile to return all profiles ([56864d2](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/56864d24c7d9c49feb663f2d0adc0dbd9407ea5a))
* Correct name from Get-EntraIDAccessTokenProfile ([34ca38a](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/34ca38a459e233126acd337a321320cef422d655))

## [2.2.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.1.2...v2.2.0) (2025-01-28)


### Features

* Add AdditionalHeaders to Get-EntraIDAccessTokenHeader ([6689cd0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/6689cd0bc9be941972c3500731330f22501517c4))

## [2.1.2](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.1.1...v2.1.2) (2025-01-24)


### Bug Fixes

* Change way of decrypting secure string to work on mac ([f360a94](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/f360a9483b81fc445c83c7a6599b89b801cb359c))

## [2.1.1](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.1.0...v2.1.1) (2025-01-23)


### Bug Fixes

* Roll back code simplification due to diff in NullString handling between ps 7.2 and 7.4 ([ce5f693](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/ce5f693251ad182604a484dcbcb5caa55122524b))

## [2.1.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.0.4...v2.1.0) (2025-01-23)


### Features

* Add ConsistencyLevelEventual parameter to Get-EntraIDAccessTokenHeader function ([5689f40](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/5689f409689eafa75e47e16ac5d5daa84ec4477b))

## [2.0.4](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.0.3...v2.0.4) (2025-01-21)


### Bug Fixes

* Fix nullable strings handling ([adb9bfe](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/adb9bfe4dac6bebd32fdd9bd35d27c4a57fc75e4))

## [2.0.3](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.0.2...v2.0.3) (2025-01-21)


### Bug Fixes

* Correct resource for automation account msi access token ([725a4c2](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/725a4c2d9a8467903be38ecd23ed5bda0f6eaa00))

## [2.0.2](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.0.1...v2.0.2) (2025-01-20)


### Bug Fixes

* Module not getting token for proper resource ([898d242](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/898d242663efddda48bdccc3624a737539379262))

## [2.0.1](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v2.0.0...v2.0.1) (2025-01-20)


### Bug Fixes

* Add default param set name for Get-EntraIDTrustingApplicationAccessToken ([ddb630b](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/ddb630bff542c7222c293bea8caad9ad0083c207))

## [2.0.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v1.1.1...v2.0.0) (2025-01-20)


### ⚠ BREAKING CHANGES

* Refactor into separate add-entraid*accesstokenprofile cmdlets

### Features

* Add untested client certificate method ([e1556b0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/e1556b0e6fb7b7f6d9796846c34d1a05cc4ac457))
* Refactor into separate add-entraid*accesstokenprofile cmdlets ([9ed3ff9](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/9ed3ff9ea802a42b79f774934ab34e071d325e8f))


### Bug Fixes

* Fix default parameter set ([290f571](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/290f5719d418d58458a14d77fb48cb2e96e8ada0))
* Mandatory access token for the extenral access token method ([395626c](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/395626c700c78cc87d89e1612f43efbe69105454))

## [1.1.1](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v1.1.0...v1.1.1) (2025-01-19)


### Bug Fixes

* Fix trusting app not working due to wrong resource ([a6f9a1c](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/a6f9a1c4e95ec862ffd5121026c85b9017fc3b46))
* Remove interactive ([8c0d05e](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/8c0d05e08f2b91e4931df950061e3302e522ef2e))

## [1.1.0](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/compare/v1.0.0...v1.1.0) (2025-01-18)


### Features

* Add ability to provide an access token to Add-EntraIDAccessTokenProfile, which is not suitable for prod, but maybe for certain test / dev situations ([e6d8bbb](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/e6d8bbb34086fb0cba5b897e7f484d8b08498cf2))
* Add Get-EntraIDAccessTokenProfile ([9927c39](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/9927c3910affc7e4d264776d2aab3e937ba69747))

## 1.0.0 (2025-01-17)


### Features

* Add release please versioning ([5d0eafd](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/5d0eafde0652180d24018fe2285daaf25b14f9dd))
* Initial release ([212f491](https://github.com/fortytwoservices/powershell-module-entraidaccesstoken/commit/212f491213fec116ba63c3adb03f14b797c51fc3))
