# fluent-plugin-filter_keys
[![Build Status](https://secure.travis-ci.org/banyan/fluent-plugin-filter_keys.png)](http://travis-ci.org/banyan/fluent-plugin-filter_keys)

## Overview

Fluentd plugin to filter if a specific key is present or not in event logs.

## Installation

```
$ gem install fluent-plugin-filter_keys
```

## Configuration

```
<match test.**>
  type filter_keys

  add_tag_prefix filter_keys.
  ensure_keys    foo, bar
</match>

<match test.**>
  type filter_keys

  add_tag_prefix filter_keys.
  denied_keys    foo, bar
</match>
```

#### ensure_keys

The keys to be existed in event logs. If it doesn't match, the event log will be discarded.

#### denied_keys

The keys to be not existed in event logs. If it matches, the event log will be discarded.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
