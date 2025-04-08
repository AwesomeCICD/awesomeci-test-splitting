<?php
use PHPUnit\Framework\TestCase;
use Demo\File82;

class File82Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File82::add(2, 3));
    }
}
