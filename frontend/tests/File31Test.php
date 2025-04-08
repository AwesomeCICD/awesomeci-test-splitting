<?php
use PHPUnit\Framework\TestCase;
use Demo\File31;

class File31Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File31::add(2, 3));
    }
}
