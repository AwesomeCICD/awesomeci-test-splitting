<?php
use PHPUnit\Framework\TestCase;
use Demo\File10;

class File10Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File10::add(2, 3));
    }
}
