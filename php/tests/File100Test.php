<?php
use PHPUnit\Framework\TestCase;
use Demo\File100;

class File100Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File100::add(2, 3));
    }
}
