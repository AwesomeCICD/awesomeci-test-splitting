<?php
use PHPUnit\Framework\TestCase;
use Demo\File80;

class File80Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File80::add(2, 3));
    }
}
