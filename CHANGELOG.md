# Changelog

## [4.0.0](https://github.com/aaryanvangari/pi-block/compare/3.3.0...4.0.0) (2025-12-23)

### Bug Fixes

* correct wording for validations ([03c7ab9](https://github.com/aaryanvangari/pi-block/commit/03c7ab9))
* fix login form validations happening to entire form on user interaction ([3a3a316](https://github.com/aaryanvangari/pi-block/commit/3a3a316))

### Features

* complete rewrite with proper BLoC architecture ([821c4d8](https://github.com/aaryanvangari/pi-block/commit/821c4d8))

## [3.3.0](https://github.com/aaryanvangari/pi-block/compare/3.2.0...3.3.0) (2025-12-23)

### Bug Fixes

* remove loading summary in system info widget ([241eaed](https://github.com/aaryanvangari/pi-block/commit/241eaed))

### Features

* add logging to models ([17271b0](https://github.com/aaryanvangari/pi-block/commit/17271b0))
* convert notifications page as stateless widget and remove fetch data ([06a3222](https://github.com/aaryanvangari/pi-block/commit/06a3222))
* expires in of session updates every second ([622ccf6](https://github.com/aaryanvangari/pi-block/commit/622ccf6))
* implement summary bloc with automatic refresh ([a87927e](https://github.com/aaryanvangari/pi-block/commit/a87927e))
* move notifications to a widget ([a1b9ed0](https://github.com/aaryanvangari/pi-block/commit/a1b9ed0))
* standardize timers throughout application ([32d4bfe](https://github.com/aaryanvangari/pi-block/commit/32d4bfe))

## [3.2.0](https://github.com/aaryanvangari/pi-block/compare/3.1.0...3.2.0) (2025-12-20)

### Features

* implement BLoC for auth ([3814f74](https://github.com/aaryanvangari/pi-block/commit/3814f74))
* move stats fetch timer to its own widget ([660f760](https://github.com/aaryanvangari/pi-block/commit/660f760))

## [3.1.0](https://github.com/aaryanvangari/pi-block/compare/3.0.0...3.1.0) (2025-12-19)

### Bug Fixes

* entitlements for network in MacOS ([cf24135](https://github.com/aaryanvangari/pi-block/commit/cf24135))

### Features

* organize notifications time ([27e4b7c](https://github.com/aaryanvangari/pi-block/commit/27e4b7c))
* refresh summary stats every 15 seconds ([0f61286](https://github.com/aaryanvangari/pi-block/commit/0f61286))

## [3.0.0](https://github.com/aaryanvangari/pi-block/compare/2.1.0...3.0.0) (2025-12-19)

### Features

* implement streams in major components ([55f201b](https://github.com/aaryanvangari/pi-block/commit/55f201b))

## [2.1.0](https://github.com/aaryanvangari/pi-block/compare/2.0.0...2.1.0) (2025-12-15)

### Bug Fixes

* remove unused import ([3460780](https://github.com/aaryanvangari/pi-block/commit/3460780))

### Features

* add copyWith function to all models ([d2b04ed](https://github.com/aaryanvangari/pi-block/commit/d2b04ed))
* all models extends Equatable ([3aa345d](https://github.com/aaryanvangari/pi-block/commit/3aa345d))
* logging models after binding in repository ([3b703a7](https://github.com/aaryanvangari/pi-block/commit/3b703a7))
* removed horizontal padding and using wrap throughout for custom tag ([a2593ca](https://github.com/aaryanvangari/pi-block/commit/a2593ca))
* standardise dividers throughout application ([e82f2e6](https://github.com/aaryanvangari/pi-block/commit/e82f2e6))
* standardise toggle switches and dynamic total switches ([c089008](https://github.com/aaryanvangari/pi-block/commit/c089008))

## [2.0.0](https://github.com/aaryanvangari/pi-block/compare/1.3.1...2.0.0) (2025-12-15)

### Features

* complete rewrite using BLOC and revamped UI ([1fc3fed](https://github.com/aaryanvangari/pi-block/commit/1fc3fed))

## [1.3.1](https://github.com/aaryanvangari/pi-block/compare/1.2.0...1.3.1) (2025-12-07)

### Bug Fixes

* dart format suggestions ([0da52f2](https://github.com/aaryanvangari/pi-block/commit/0da52f2))
* fix validators package inclusion ([83ed695](https://github.com/aaryanvangari/pi-block/commit/83ed695))

### Features

* change seed color to custom blue ([a40ade6](https://github.com/aaryanvangari/pi-block/commit/a40ade6))
* standardize border radius, change from "login" to "get started" ([5740587](https://github.com/aaryanvangari/pi-block/commit/5740587))
* standardize border radius, implement custom validators ([c9a3035](https://github.com/aaryanvangari/pi-block/commit/c9a3035))
* standardize border radius, showing trailing icon when description available, increased duration ([3cc8da4](https://github.com/aaryanvangari/pi-block/commit/3cc8da4))

## [1.2.0](https://github.com/aaryanvangari/pi-block/compare/1.1.2...1.2.0) (2025-12-06)

### Bug Fixes

* fix content going below bottom navigation bar ([c06bc25](https://github.com/aaryanvangari/pi-block/commit/c06bc25))
* fix data binding issues from int to double ([6d9f431](https://github.com/aaryanvangari/pi-block/commit/6d9f431))

### Features

* from card view to simple list view with expansion tiles ([9bd2ce6](https://github.com/aaryanvangari/pi-block/commit/9bd2ce6))
* handle null checks ([d04076f](https://github.com/aaryanvangari/pi-block/commit/d04076f))

## [1.1.2](https://github.com/aaryanvangari/pi-block/compare/1.1.1...1.1.2) (2025-12-05)

## [1.1.1](https://github.com/aaryanvangari/pi-block/compare/1.1.0...1.1.1) (2025-12-05)

### Features

* ignore duplicate headings in markdown files ([2d525b6](https://github.com/aaryanvangari/pi-block/commit/2d525b6))

## [1.1.0](https://github.com/aaryanvangari/pi-block/compare/1.0.0...1.1.0) (2025-12-05)

### Bug Fixes

* fix paddings and null checks ([65a025d](https://github.com/aaryanvangari/pi-block/commit/65a025d))

### Features

* add system load and gradient colors in blocking timers grid ([2aa6332](https://github.com/aaryanvangari/pi-block/commit/2aa6332))
* re-order blocking dropdown icon into its block ([086fd06](https://github.com/aaryanvangari/pi-block/commit/086fd06))
* revamped welcome screen with emphasizing login button ([af250b3](https://github.com/aaryanvangari/pi-block/commit/af250b3))
* using models for data binding ([0c13b5c](https://github.com/aaryanvangari/pi-block/commit/0c13b5c))

## [1.0.0](https://github.com/aaryanvangari/pi-block/compare/0.1.0...1.0.0) (2025-12-04)

### Bug Fixes

* fix using BuildContext in async gaps ([8c87d45](https://github.com/aaryanvangari/pi-block/commit/8c87d45))

### Features

* initial import ([ab433fd](https://github.com/aaryanvangari/pi-block/commit/ab433fd))
