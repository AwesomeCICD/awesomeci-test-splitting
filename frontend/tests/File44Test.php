<?php
use PHPUnit\Framework\TestCase;
use Demo\File44;

class File44Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File44::add(2, 3));
    }
}
