<?php
use PHPUnit\Framework\TestCase;
use Demo\File86;

class File86Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File86::add(2, 3));
    }
}
