<?php
use PHPUnit\Framework\TestCase;
use Demo\File71;

class File71Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File71::add(2, 3));
    }
}
