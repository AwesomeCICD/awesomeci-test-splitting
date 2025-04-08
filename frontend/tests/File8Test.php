<?php
use PHPUnit\Framework\TestCase;
use Demo\File8;

class File8Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File8::add(2, 3));
    }
}
