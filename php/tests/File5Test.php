<?php
use PHPUnit\Framework\TestCase;
use Demo\File5;

class File5Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File5::add(2, 3));
    }
}
