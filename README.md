<a href="https://onyxframework.org"><img width="100" height="100" src="https://onyxframework.org/img/logo.svg"></a>

# Onyx

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?style=flat-square)](https://crystal-lang.org/)
[![Travis CI build](https://img.shields.io/travis/onyxframework/onyx/stable.svg?style=flat-square)](https://travis-ci.org/onyxframework/onyx)
[![Docs](https://img.shields.io/badge/docs-online-brightgreen.svg?style=flat-square)](https://docs.onyxframework.org)
[![API docs](https://img.shields.io/badge/api_docs-online-brightgreen.svg?style=flat-square)](https://api.onyxframework.org/onyx)
[![Latest release](https://img.shields.io/github/release/onyxframework/onyx.svg?style=flat-square)](https://github.com/onyxframework/onyx/releases)

Powerful framework for modern applications.

## About 👋

Onyx Framework is a powerful general purpose framework for [Crystal language](https://crystal-lang.org/). It has the following goals:

* **Joy** for newcomers, yet an ability to scale with the developer's knowledge
* **Type-safety** on top of Crystal's amazing built-in type system
* **Performance** having minimum possible overhead

The framework consists of the following loosely coupled components:

* [Onyx::HTTP](https://github.com/onyxframework/http) to build scalable web applications
* [Onyx::SQL](https://github.com/onyxframework/sql) to add SQL models to your business layer
* [Onyx::EDA](https://github.com/onyxframework/eda) to implement events-based reactivity

## Supporters 🕊

Thanks to all these patrons, the framework lives and prospers 🙏

[Lauri Jutila](https://github.com/ljuti), [Alexander Maslov](https://seendex.ru), Dainel Vera

*You can become a patron too in exchange of prioritized support and other perks*

<a href="https://www.patreon.com/vladfaust"><img height="50" src="https://onyxframework.org/img/patreon-button.svg"></a>

## Installation 📥

Add this to your application's `shard.yml`:

```yaml
dependencies:
  onyx:
    github: onyxframework/onyx
    version: ~> 0.3.0
```

This shard follows [Semantic Versioning v2.0.0](http://semver.org/), so check [releases](https://github.com/onyxframework/rest/releases) and change the `version` accordingly. Please visit [github.com/crystal-lang/shards](https://github.com/crystal-lang/shards) to know more about Crystal shards.

Note that this shard does **not** have implicit dependencies for other framework components. For example, to use `"onyx/http"` macros, you must add `onyx-http` dependendency as well:

```yaml
dependencies:
  onyx:
    github: onyxframework/onyx
    version: ~> 0.3.0
  onyx-http:
    github: onyxframework/http
    version: ~> 0.7.0
```

## Documentation 📚

The documentation is available online at [docs.onyxframework.org](https://docs.onyxframework.org).

## Community 🍪

There are multiple places to talk about this particular shard and about other ones as well:

* [Gitter](https://gitter.im/onyxframework/Lobby)
* [Twitter](https://twitter.com/onyxframework)

## Contributing

1. Fork it ( https://github.com/onyxframework/onyx/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'feat: some feature') using [Angular style commits](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Vlad Faust](https://github.com/vladfaust) - creator and maintainer

## Licensing

This software is licensed under [MIT License](LICENSE).

[![Open Source Initiative](https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Opensource.svg/100px-Opensource.svg.png)](https://opensource.org/licenses/MIT)
