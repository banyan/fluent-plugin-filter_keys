# fluent-plugin-filter_keys
[![Build Status](https://secure.travis-ci.org/banyan/fluent-plugin-filter_keys.png)](http://travis-ci.org/banyan/fluent-plugin-filter_keys)

## Overview

[Fluentd](http://fluentd.org) plugin to filter if a specific key is present or not in event logs.

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

Keys to be existed in a event log. If it doesn't match, the event log will be discarded.

#### denied_keys

Keys to be not existed in a event log. If it matches, the event log will be discarded.

#### add_tag_and_reemit

Default false. if this configure parameter is true and doesn't match keys, add tag 'discarded' and reemit.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
