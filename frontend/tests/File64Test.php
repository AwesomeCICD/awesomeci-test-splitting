<?php
use PHPUnit\Framework\TestCase;
use Demo\File64;

class File64Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File64::add(2, 3));
    }
}
