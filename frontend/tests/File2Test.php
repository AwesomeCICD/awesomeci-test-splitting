<?php
use PHPUnit\Framework\TestCase;
use Demo\File2;

class File2Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File2::add(2, 3));
    }
}
