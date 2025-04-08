<?php
use PHPUnit\Framework\TestCase;
use Demo\File52;

class File52Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File52::add(2, 3));
    }
}
