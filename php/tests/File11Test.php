<?php
use PHPUnit\Framework\TestCase;
use Demo\File11;

class File11Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File11::add(2, 3));
    }
}
