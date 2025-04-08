<?php
use PHPUnit\Framework\TestCase;
use Demo\File93;

class File93Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File93::add(2, 3));
    }
}
