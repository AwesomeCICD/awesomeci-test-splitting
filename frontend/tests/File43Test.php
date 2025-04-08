<?php
use PHPUnit\Framework\TestCase;
use Demo\File43;

class File43Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File43::add(2, 3));
    }
}
