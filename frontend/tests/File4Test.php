<?php
use PHPUnit\Framework\TestCase;
use Demo\File4;

class File4Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File4::add(2, 3));
    }
}
