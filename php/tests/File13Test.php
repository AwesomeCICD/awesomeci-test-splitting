<?php
use PHPUnit\Framework\TestCase;
use Demo\File13;

class File13Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File13::add(2, 3));
    }
}
