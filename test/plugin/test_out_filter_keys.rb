# coding: utf-8

require 'test_helper'
require 'fluent/plugin/out_filter_keys'

class FilterKeysOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf)
    Fluent::Test::Driver::Output.new(
      Fluent::FilterKeysOutput
    ).configure(conf)
  end

  def test_configure_on_success
    d = create_driver(%[
      add_tag_prefix filter_keys.
      ensure_keys    zoo, woo
    ])

    assert_equal 'filter_keys.', d.instance.add_tag_prefix
    assert_equal %w(zoo woo),    d.instance.ensure_keys
  end

  def test_configure_on_failure
    # when mandatory keys not set
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        blah blah
      ])
    end

    # when ensure_keys and denied_keys are both set
    assert_raise(Fluent::ConfigError) do
      create_driver(%[
        add_tag_prefix filter_keys.
        ensure_keys    zoo, woo
        denied_keys    foo, bar
      ])
    end
  end

  def test_emit_with_ensure_keys_exists
    d = create_driver(%[
      ensure_keys foo
      add_tag_prefix filter_keys.
    ])

    record = {
      'foo' => "50",
      'bar' => "100",
    }

    d.run(default_tag: 'test') { d.feed(record) }
    emits = d.events

    assert_equal 1,                  emits.count
    assert_equal 'filter_keys.test', emits[0][0]
    assert_equal '50',               emits[0][2]['foo']
    assert_equal '100',              emits[0][2]['bar']
  end

  def test_emit_with_ensure_keys_exists_on_multiple_arguments
    d = create_driver(%[
      ensure_keys    foo, bar
      add_tag_prefix filter_keys.
    ])

    record = {
      'foo' => "50",
      'bar' => "100",
    }

    d.run(default_tag: 'test') { d.feed(record) }
    emits = d.events

    assert_equal 1,                  emits.count
    assert_equal 'filter_keys.test', emits[0][0]
    assert_equal '50',               emits[0][2]['foo']
    assert_equal '100',              emits[0][2]['bar']
  end

  def test_emit_with_ensure_keys_not_exists
    d = create_driver(%[
      ensure_keys    foo
      add_tag_prefix filter_keys.
    ])

    record = {
      'not' => "match",
      'at'  => "all",
    }

    d.run(default_tag: 'test') { d.feed(record) }
    emits = d.events

    assert_equal 0,  emits.count
    assert_equal [], emits
  end

  def test_emit_with_ensure_keys_not_exists_on_multiple_arguments
    d = create_driver(%[
      ensure_keys foo, bar
      add_tag_prefix   filter_keys.
    ])

    record = {
      'foo' => "50",
    }

    d.run(default_tag: 'test') { d.feed(record) }
    emits = d.events

    assert_equal 0,  emits.count
    assert_equal [], emits
  end

  def test_emit_with_denied_keys_exists
    d = create_driver(%[
      denied_keys    foo
      add_tag_prefix filter_keys.
    ])

    record = {
      'foo' => "50",
      'bar' => "100",
    }

    d.run(default_tag: 'test') { d.feed(record) }
    emits = d.events

    assert_equal 0,  emits.count
    assert_equal [], emits
  end

  def test_emit_with_denied_keys_not_exists
    d = create_driver(%[
      denied_keys    foo
      add_tag_prefix filter_keys.
    ])

    record = {
      'baz' => "50",
      'bar' => "100",
    }

    d.run(default_tag: 'test') { d.feed(record) }
    emits = d.events

    assert_equal 1,                  emits.count
    assert_equal 'filter_keys.test', emits[0][0]
    assert_equal '50',               emits[0][2]['baz']
    assert_equal '100',              emits[0][2]['bar']
  end

  def test_emit_multi_records
    d = create_driver(%[
      add_tag_prefix filter_keys.
      ensure_keys    baz
    ])

    record = {
      'baz' => "50",
      'bar' => "100",
    }

    d.run(default_tag: 'test') do
      3.times { d.feed(record) }
    end
    emits = d.events

    assert_equal 3, emits.count

    emits.each do |e|
      assert_equal 'filter_keys.test', e[0]
      assert_equal '50',               e[2]['baz']
      assert_equal '100',              e[2]['bar']
    end
  end

  def test_emit_when_record_discarded
    d = create_driver(%[
      ensure_keys    foo, bar
      add_tag_prefix filter_keys.
      add_tag_and_reemit true
    ])

    record = {
      'foo' => "50",
    }

    d.run(default_tag: 'test') { d.feed(record) }
    emits = d.events

    assert_equal 1,                  emits.count
    assert_equal 'discarded.filter_keys.test', emits[0][0]
    assert_equal '50',               emits[0][2]['foo']
  end
end
