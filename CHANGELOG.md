# Changelog

## [v5.3.1](https://github.com/aaryanvangari/pi-block/compare/v5.3.0...v5.3.1) (2026-01-04)

### 🐛 Bug Fixes

* groups are not pre selected for the first time ([3900316](https://github.com/aaryanvangari/pi-block/commit/3900316bdd829f85897e626365e8161afc05964e)).
* list content does not fit properly which is caused by iconbutton taking more space ([93ebedc](https://github.com/aaryanvangari/pi-block/commit/93ebedca8b7323b1fb216ea1fe762759c464509a)).
* when 'about an hour ago' occurs content is overflowing so using 'Saved' instead of 'Downloaded' ([f431189](https://github.com/aaryanvangari/pi-block/commit/f431189bace2f813de4e628ecba97912c437bfec)).
* fix welcome and login buttons to be similar ([7858619](https://github.com/aaryanvangari/pi-block/commit/785861919a03306349764a461728656f81448b29)).

## [v5.3.0](https://github.com/aaryanvangari/pi-block/compare/v5.2.0...v5.3.0) (2026-01-03)

### ✨ Features

* architectural correctness regarding rxdart and streams ([9d9f2dd](https://github.com/aaryanvangari/pi-block/commit/9d9f2dd54cc8191be6f42a4e5f86f403ab977fde)).

## [v5.2.0](https://github.com/aaryanvangari/pi-block/compare/v5.1.0...v5.2.0) (2026-01-03)

### 🐛 Bug Fixes

* fix issues while searching in querylog page ([b00cb6d](https://github.com/aaryanvangari/pi-block/commit/b00cb6d87e01f4538c83fb507763d7c74a249f01)).

## [v5.1.0](https://github.com/aaryanvangari/pi-block/compare/v5.0.2...v5.1.0) (2026-01-02)

### ✨ Features

* add logs in readme ([fbf6432](https://github.com/aaryanvangari/pi-block/commit/fbf6432f350838c1afcf9625067d7abccd2906c8)).
* implement pi-hole logs ([6b80da7](https://github.com/aaryanvangari/pi-block/commit/6b80da71a28925c6395c00e817fe73d6d380fda2)).
* update readme with current developments ([75aa5c0](https://github.com/aaryanvangari/pi-block/commit/75aa5c0820373e2b7bfb6c6b02432c8dd771905c)).
* get edit and delete icon colors from theme ([57c3192](https://github.com/aaryanvangari/pi-block/commit/57c31921e596719a8c942640897e912ca67eb0c9)).
* red color for delete icon to notify its danger action ([84d7784](https://github.com/aaryanvangari/pi-block/commit/84d77845818f6926bc0e9994830f51f63a8233bf)).
* add tooltips for buttons in grid view cards ([1bd2f77](https://github.com/aaryanvangari/pi-block/commit/1bd2f77c6c5970114d47d1c2ea218f24588f95d5)).
* search for domains in querylog page ([1a2edca](https://github.com/aaryanvangari/pi-block/commit/1a2edca230ed5139fba0e6cc1534f20f944f77cc)).
* custom label style for pie charts ([38cf704](https://github.com/aaryanvangari/pi-block/commit/38cf704e1c95677ec8bd4aa31b9a2c252e60c0b5)).
* add dns and dhcp metrics ([3021f1f](https://github.com/aaryanvangari/pi-block/commit/3021f1f7dc5482da75a8e58a32d434244b6a0627)).
* responsive design with cards for all pages ([c9e0b28](https://github.com/aaryanvangari/pi-block/commit/c9e0b2839b1c283449cd5cc57ff74fe65f361f43)).
* suggestions while adding clients ([6b4cb8f](https://github.com/aaryanvangari/pi-block/commit/6b4cb8f788574ebbb9deea33eeaca0dc0fcd6682)).
* add clients page ([f3d9516](https://github.com/aaryanvangari/pi-block/commit/f3d951610656b2f7323dc721047337c1a93b7fe6)).
* organize client stats with new model, route, data methods ([256341f](https://github.com/aaryanvangari/pi-block/commit/256341f88c9d6f669dbad0abe293d3edd832d32d)).
* responsive stats page ([ba23fe1](https://github.com/aaryanvangari/pi-block/commit/ba23fe1c3dcb882952af99460af12a2f0941675f)).
* responsive main scaffold ([b7fd669](https://github.com/aaryanvangari/pi-block/commit/b7fd669844450e47cf4eff4289004dfdc3a6d723)).
* responsive dashboard ([1205e63](https://github.com/aaryanvangari/pi-block/commit/1205e63c3f73889720c5ac87c918b31cdc228968)).
* responsive WoltModalSheet ([f6ae8db](https://github.com/aaryanvangari/pi-block/commit/f6ae8db5d2f9fa9ffc36d959ef51df1d981817ae)).
* generalize delete actions into a widget ([67016fc](https://github.com/aaryanvangari/pi-block/commit/67016fcd508ce7daa661b7b5b3e084bc61b34a5d)).
* add groups page and groups dropdown in lists, domains pages ([a79f561](https://github.com/aaryanvangari/pi-block/commit/a79f561bb031d9106d5fe5532397d2df6aa71fed)).
* organize logging ([575f24e](https://github.com/aaryanvangari/pi-block/commit/575f24ec0e3110046736dcbc7ab905da2eabcf11)).

### 🐛 Bug Fixes

* fix clients barchart tooltips overflow in desktop mode ([64cc61e](https://github.com/aaryanvangari/pi-block/commit/64cc61e8f14fef825387098eb2e73fbc33fa24d3)).
* fix piechart label and legend colors ([a6fda58](https://github.com/aaryanvangari/pi-block/commit/a6fda58f9a1f091272840100481cd12a6a2c188f)).
* responsive issues on stats page for dns cache widget ([d30da4e](https://github.com/aaryanvangari/pi-block/commit/d30da4e9eb981d080663a8fb2c879fa136adce87)).
* remove commented code ([2ad0c6d](https://github.com/aaryanvangari/pi-block/commit/2ad0c6d1c0461b451f8a249e0a5b9c03aecaaecd)).
* fix issue where drawer can be removed from navigation in desktop mode ([c6a2545](https://github.com/aaryanvangari/pi-block/commit/c6a2545d2f79632e2c699b3a3fca84e25e862143)).
* tooltip issue in mobile clients ([316aa46](https://github.com/aaryanvangari/pi-block/commit/316aa46199d71d96583ddfe4bb2b0c8c7da48f06)).

## [v5.0.2](https://github.com/aaryanvangari/pi-block/compare/v5.0.1...v5.0.2) (2025-12-28)

## [v5.0.1](https://github.com/aaryanvangari/pi-block/compare/5.0.0...v5.0.1) (2025-12-28)

## [5.0.0](https://github.com/aaryanvangari/pi-block/compare/4.0.0...5.0.0) (2025-12-28)

### ✨ Features

* responsive layout for welcome and login pages ([586bf2f](https://github.com/aaryanvangari/pi-block/commit/586bf2fa5a0b69b80d92607957461d8b6ef51040)).
* revamp GoRouter ([e5bc84f](https://github.com/aaryanvangari/pi-block/commit/e5bc84fdd99f23ac7ff0512720152cdadef75192)).
* revamp modal sheets using wolt_modal_sheet ([9e2d90f](https://github.com/aaryanvangari/pi-block/commit/9e2d90f10113d11a31e6fc1494e247fbd19f6855)).
* new application icons ([7483df3](https://github.com/aaryanvangari/pi-block/commit/7483df31d7dd41322c08574152da7e02b5e35097)).
* load credentials from environment files for dev ([3397725](https://github.com/aaryanvangari/pi-block/commit/33977253816451be4c4f4e560a7532c97f22b80f)).
* minimalistic welcome screen ([b085d6c](https://github.com/aaryanvangari/pi-block/commit/b085d6cb7b26476101286feb459c23a6806fe3b2)).
* implement theme the right way ([1206c08](https://github.com/aaryanvangari/pi-block/commit/1206c08db43383d7a9af3a7379bb3cb0c1b5e3da)).
* implement hive for auth and settings ([c1fb174](https://github.com/aaryanvangari/pi-block/commit/c1fb1740a370ddd126437aee4c81f3ee5171a6af)).
* generalized error color in lists ([aceb6e3](https://github.com/aaryanvangari/pi-block/commit/aceb6e3aae2837b82b8b9a880c4875f15df9d830)).
* make stateless widgets if state is not necessary ([5abcd2b](https://github.com/aaryanvangari/pi-block/commit/5abcd2b6fbad9fc7b8e01e4384c1437eaccdc9a3)).
* move common logic in charts to chart manager ([6de3705](https://github.com/aaryanvangari/pi-block/commit/6de3705990d20fe6b8187beb17df795cd5c658c0)).
* implement and use waiting card widget ([d901562](https://github.com/aaryanvangari/pi-block/commit/d901562ef784e85209effb11fdc39af83f598e63)).
* standardize form text fields borders ([e2fa1e6](https://github.com/aaryanvangari/pi-block/commit/e2fa1e64a0f494034da61bf784896ae77cbec29e)).
* organize constants ([ccecdb6](https://github.com/aaryanvangari/pi-block/commit/ccecdb6245ed3cf7affcba4c9f6d67d129568419)).
* move all static colors to constants ([e1fad61](https://github.com/aaryanvangari/pi-block/commit/e1fad613db0859fd36c83b0cf4fce776ecb292d2)).

### 🐛 Bug Fixes

* loading environment variables from OS level and not from .env file ([ea14b2d](https://github.com/aaryanvangari/pi-block/commit/ea14b2d28712bca0283e082ebd0ca74d6c609d5a)).
* gracefully exiting when exception happens in logout ([71d8c36](https://github.com/aaryanvangari/pi-block/commit/71d8c368bea120138553d438957e32b8c06045da)).
* increase max line length for markdown files especially CHANGELOG.md ([cae3ccb](https://github.com/aaryanvangari/pi-block/commit/cae3ccb87db27ff6751e2e82b237cc29f00f0a81)).
* layout issues in querylog are solved ([659a5f2](https://github.com/aaryanvangari/pi-block/commit/659a5f2df06c16275a98cc16d36f4d830990ca5e)).
* fix bar chart tooltips overflowing ([074528b](https://github.com/aaryanvangari/pi-block/commit/074528b0cd1918e1ee50055ccff7ee37e6bbe64c)).
* fix updating app ui token colors on the fly when theme changes ([4a2192b](https://github.com/aaryanvangari/pi-block/commit/4a2192b4a36994a7a11803ce13710f31faeeb6e0)).
* returning content from builder instead of widgets ([8b0d95c](https://github.com/aaryanvangari/pi-block/commit/8b0d95c72072d398bdb4bf1f648b2be466e3e65c)).

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
