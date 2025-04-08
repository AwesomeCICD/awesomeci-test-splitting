<?php
use PHPUnit\Framework\TestCase;
use Demo\File77;

class File77Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File77::add(2, 3));
    }
}
