<?php
use PHPUnit\Framework\TestCase;
use Demo\File15;

class File15Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File15::add(2, 3));
    }
}
