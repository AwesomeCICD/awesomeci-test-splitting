<?php
use PHPUnit\Framework\TestCase;
use Demo\File61;

class File61Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File61::add(2, 3));
    }
}
