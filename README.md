# ROR

`ROR` is an unofficial client for the [Research Organization Registry (ROR)](https://ror.org) API for Elixir, Erlang or 
any other BEAM language.

> The Research Organization Registry (ROR) includes IDs and metadata for more than 110,000 organizations and counting.
> Registry data is CC0 and openly available via a search interface, REST API, and data dump. Registry updates are curated
> through a community process and released at least once a month

Please read ROR's [terms of use](https://ror.org/about/terms/) and do not put excessive load on their API service. 

[![Hex pm](http://img.shields.io/hexpm/v/ror.svg?style=flat)](https://hex.pm/packages/ror)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/ror/)
![Github Elixir CI](https://github.com/Digital-Identity-Labs/ror/workflows/Elixir%20CI/badge.svg)

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fraw.githubusercontent.com%2FDigital-Identity-Labs%2Fror%2Fmain%2Fror_notebook.livemd)

## Features

* Lookup individual ROR records by ID
* Search and Quick Search based on names or record attributes
* Paging and filters are supported
* Match text to records, possibly identifying an organisation from existing data
* Records are returned as typed structs (slight different to the ROR JSON responses, but containing all the information)
* Client ID authentication is supported and optional
* (This is an early version and only contains the basics so far)

The top level `ROR` module contains functions for retrieving data from the API. Other ROR modules may not be needed at all.

* `ROR.Client` presents a lower-level way to retrieve data, and returns maps based on the literal ROR JSON responses.
* `ROR.Organization` contains a struct and utilities for the main ROR organization record
* `ROR.Results` is an enumerable struct that contains both Organizations and metadata
* `ROR.Matches` is another enumerable struct, which contains results from affiliation searches

## Examples

### Retrieving data about an organization using its ROR ID

```elixir
org = ROR.get!("https://ror.org/04h699437")
org.domains
# => ["le.ac.uk"],

```

### List ROR records, specifying a page and a filter

```elixir
ROR.list!(page: 15, filter: [type: :government])
|> Enum.map(fn org -> org.id end)
# => ["https://ror.org/05m615h78", "https://ror.org/04wbxh769",
#     "https://ror.org/04xh10z69", "https://ror.org/0127sq784",
#     "https://ror.org/021c40092", "https://ror.org/00wyejx41",
#     "https://ror.org/01q5ara80", "https://ror.org/05sej3528",
#     "https://ror.org/024nbjg39", "https://ror.org/00n523x67",
#     "https://ror.org/02zqy3981", "https://ror.org/0320bge18",
#     "https://ror.org/02jcwf181", "https://ror.org/02m388s04",
#     "https://ror.org/01r2man76", "https://ror.org/05335sh79",
#     "https://ror.org/03hwfnp11", "https://ror.org/01wsx6q69",
#     "https://ror.org/042jr0j26", "https://ror.org/03y255h89"]
```

### A quick search 

```elixir
a = ROR.quick_search!("University of Manchester")
    |> Enum.take(1)
    |> List.first()
a.established
# => 1824

```

### An affiliation search for strong match or nil, also showing off the string conversion feature

```elixir
org = ROR.chosen_organization!("CERN")
Enum.map(org.names, &to_string/1)
# => ["CERN", "European Organization for Nuclear Research",
#     "Europäische Organisation für Kernforschung",
#     "Organisation européenne pour la recherche nucléaire"]

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ror` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ror, "~> 0.1.0"}
  ]
end
```

## References

### ROR Resources
* [ROR website](https://ror.org)
* [ROR API Documentation](https://ror.readme.io/v2/docs/basics)
* [Projects using ROR](https://airtable.com/app2Tnq1uCHnS8HQD/shrM876d6Koi1UONe/tbljRW9VeQOqY6oOg?backgroundColor=gray&viewControls=on)

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ror>.

## Contributing

You can request new features by creating an [issue](https://github.com/Digital-Identity-Labs/ror/issues),
or submit a [pull request](https://github.com/Digital-Identity-Labs/ror/pulls) with your contribution.

If you are comfortable working with Python but ROR's Elixir code is unfamiliar then this blog post may help: 
[Elixir For Humans Who Know Python](https://hibox.live/elixir-for-humans-who-know-python)

## Copyright and License

Copyright (c) 2025 Digital Identity Ltd, UK

ROR is MIT licensed.

## Disclaimer
This Elixir ROR library is not endorsed by The Research Organization Registry (ROR)
This software may change considerably in the first few releases after 0.1.0 - it is not yet stable!