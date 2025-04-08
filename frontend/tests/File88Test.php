<?php
use PHPUnit\Framework\TestCase;
use Demo\File88;

class File88Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File88::add(2, 3));
    }
}
