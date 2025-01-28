# Changelog

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
