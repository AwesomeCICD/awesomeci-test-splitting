<?php
use PHPUnit\Framework\TestCase;
use Demo\File97;

class File97Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File97::add(2, 3));
    }
}
