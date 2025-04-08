<?php
use PHPUnit\Framework\TestCase;
use Demo\File62;

class File62Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File62::add(2, 3));
    }
}
