<?php
use PHPUnit\Framework\TestCase;
use Demo\File47;

class File47Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File47::add(2, 3));
    }
}
