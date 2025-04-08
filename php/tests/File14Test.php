<?php
use PHPUnit\Framework\TestCase;
use Demo\File14;

class File14Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File14::add(2, 3));
    }
}
