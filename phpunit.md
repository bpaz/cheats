---
title: PHPunit
category: php
layout: 2017/sheet
updated: 2018-10-30
description: "PHPUnit is a programmer-oriented testing framework for PHP.
It is an instance of the xUnit architecture for unit testing frameworks"
---

### Install

```
 composer require --dev phpunit/phpunit
 ```

### Run tests


```php
./vendor/bin/phpunit --bootstrap vendor/autoload.php tests # All tests
./vendor/bin/phpunit --filter  tests/Feature/UserTest.php # single class
./vendor/bin/phpunit --filter testExample  # single method
```

### Example Test case

```php
<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class EmailTest extends TestCase
{
    public function testCanBeCreatedFromValidEmailAddress(): void
    {
        $this->assertInstanceOf(
            Email::class,
            Email::fromString('user@example.com')
        );
    }

    public function testCannotBeCreatedFromInvalidEmailAddress(): void
    {
        $this->expectException(InvalidArgumentException::class);

        Email::fromString('invalid');
    }

    public function testCanBeUsedAsString(): void
    {
        $this->assertEquals(
            'user@example.com',
            Email::fromString('user@example.com')
        );
    }
}
```

### Composing a Test Suite Using XML Configuration phpunit.xml

```
<phpunit bootstrap="src/autoload.php">
  <testsuites>
    <testsuite name="money">
      <directory>tests</directory>
    </testsuite>
  </testsuites>
</phpunit>
```



## References
{: .-one-column}

* <https://phpunit.de/getting-started/phpunit-7.html>
* <https://www.laracasts.com/series/phpunit-testing-in-laravel>